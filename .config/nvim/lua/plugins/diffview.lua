-- Merge conflict resolution UI. Every other git operation goes through lazygit,
-- so only the merge tool is wired up here.
-- https://github.com/sindrets/diffview.nvim
return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
  cmd = { "DiffviewOpen", "DiffviewClose" },
  keys = {
    {
      "<Leader>gv",
      function()
        -- Toggle: close when the current tabpage already is a Diffview
        if require("diffview.lib").get_current_view() then
          vim.cmd("DiffviewClose")
        else
          vim.cmd("DiffviewOpen")
        end
      end,
      desc = "Diffview Toggle (merge conflicts)",
    },
  },
  opts = function()
    local actions = require("diffview.actions")
    local palette = require("config.palette")

    -- `diff1_plain` shows one plain window, so none of the built-in diff
    -- highlighting applies — the conflict regions are just text. Tint them
    -- ourselves: OURS / BASE / THEIRS each get their own background, with a
    -- stronger shade on the marker lines themselves.
    -- Body groups set `bg` only, so they layer under treesitter like CursorLine
    -- does and leave the syntax colors intact.
    local sections = {
      Ours = { body = "#1c2724", marker = "#27372b", fg = palette.green },
      Base = { body = "#1e202b", marker = "#2a2d3a", fg = palette.gray },
      Theirs = { body = "#1e2433", marker = "#28324a", fg = palette.blue },
    }
    for name, c in pairs(sections) do
      vim.api.nvim_set_hl(0, "MergeConflict" .. name, { bg = c.body })
      vim.api.nvim_set_hl(0, "MergeConflict" .. name .. "Marker", { bg = c.marker, fg = c.fg, bold = true })
    end

    local ns = vim.api.nvim_create_namespace("merge_conflict_hl")
    local attached, pending = {}, {}

    ---Paint every conflict region in `bufnr`. Cheap enough to just redo the
    ---whole buffer on each change — conflicted files are resolved and gone.
    local function render(bufnr)
      if not vim.api.nvim_buf_is_valid(bufnr) then
        return
      end
      vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      for _, conflict in ipairs(require("diffview.vcs.utils").parse_conflicts(lines)) do
        -- `first` is the marker line and `last` the section's final content
        -- line — except for THEIRS, whose `last` is the closing `>>>>>>>`.
        local parts = {
          { name = "Ours", first = conflict.ours.first, last = conflict.ours.last },
          { name = "Base", first = conflict.base.first, last = conflict.base.last },
          { name = "Theirs", first = conflict.theirs.first, last = conflict.theirs.last, closing = true },
        }

        for _, part in ipairs(parts) do
          -- BASE is missing unless git wrote it (merge.conflictStyle)
          if part.first and part.last then
            local body_last = part.closing and part.last - 1 or part.last
            local function paint(lnum, group)
              vim.api.nvim_buf_set_extmark(bufnr, ns, lnum - 1, 0, { line_hl_group = group })
            end

            paint(part.first, "MergeConflict" .. part.name .. "Marker")
            for lnum = part.first + 1, body_last do
              paint(lnum, "MergeConflict" .. part.name)
            end
            if part.closing then
              paint(part.last, "MergeConflict" .. part.name .. "Marker")
            end
          end
        end
      end
    end

    -- Upstream binds conflict resolution under <Leader>c, which collides with
    -- the global <Leader>c (toggle comment). <Leader>c is a *complete* match,
    -- so Vim has to disambiguate:
    --   * diff buffer  — waits out 'timeoutlen' (1s) on every <Leader>c
    --   * file panel   — the lowercase variants don't even exist there, so the
    --                    comment toggle just runs instead
    -- Rebind the whole set under <leader>m (merge) and drop the defaults, so
    -- neither prefix is ambiguous anymore.
    --
    -- NOTE: keep `<leader>` lowercase here. diffview merges user keymaps over
    -- its defaults keyed on the raw `mode .. " " .. lhs` string, so spelling it
    -- `<Leader>` silently adds a second mapping instead of replacing the
    -- default — the `false` entries below would then disable nothing.
    local choices = {
      { key = "o", version = "ours", label = "OURS" },
      { key = "t", version = "theirs", label = "THEIRS" },
      { key = "b", version = "base", label = "BASE" },
      { key = "a", version = "all", label = "all versions" },
    }

    local region_maps = {} -- single conflict region: diff buffer only
    local file_maps = {} -- whole file: diff buffer and file panel

    for _, c in ipairs(choices) do
      local upper = c.key:upper()
      vim.list_extend(region_maps, {
        { "n", "<leader>c" .. c.key, false },
        {
          "n",
          "<leader>m" .. c.key,
          actions.conflict_choose(c.version),
          { desc = "Choose " .. c.label .. " (conflict region)" },
        },
      })
      vim.list_extend(file_maps, {
        { "n", "<leader>c" .. upper, false },
        {
          "n",
          "<leader>m" .. upper,
          actions.conflict_choose_all(c.version),
          { desc = "Choose " .. c.label .. " (whole file)" },
        },
      })
    end

    local view_maps = {}
    vim.list_extend(view_maps, region_maps)
    vim.list_extend(view_maps, file_maps)

    -- Only on the panel: leave `q` free for macro recording in the buffer
    -- where conflicts are actually edited
    local panel_maps = { { "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "Close Diffview" } } }
    vim.list_extend(panel_maps, file_maps)

    return {
      view = {
        merge_tool = {
          -- Single window showing the working copy with raw conflict markers:
          -- OURS / BASE / THEIRS are all in the buffer, no diff splits needed.
          -- The BASE section only exists when git writes it — see
          -- `merge.conflictStyle = zdiff3` in .config/git/config.
          layout = "diff1_plain",
        },
      },
      keymaps = {
        view = view_maps,
        file_panel = panel_maps,
      },
      hooks = {
        -- sunglasses.nvim shades the unfocused window by 50%. With a single
        -- diff window, that means the conflict itself dims whenever the file
        -- panel is focused. Its default exclusions cover the panels, not this
        -- buffer. view_enter/view_leave also fire on tabpage switches, so
        -- shading comes back as soon as the Diffview tab is left (not only
        -- when it's closed).
        view_enter = function()
          pcall(vim.cmd, "SunglassesDisable")
        end,
        view_leave = function()
          pcall(vim.cmd, "SunglassesEnable")
        end,
        diff_buf_win_enter = function(bufnr)
          render(bufnr)
          if attached[bufnr] then
            return
          end
          attached[bufnr] = true

          -- Regions shift and disappear as conflicts get resolved. TextChanged
          -- is no good here: the `conflict_choose` actions rewrite the buffer
          -- through the API, which doesn't fire it. on_lines catches every
          -- change, and scheduling coalesces bursts into one repaint.
          vim.api.nvim_buf_attach(bufnr, false, {
            on_lines = function()
              if pending[bufnr] then
                return
              end
              pending[bufnr] = true
              vim.schedule(function()
                pending[bufnr] = nil
                render(bufnr)
              end)
            end,
            on_detach = function()
              attached[bufnr], pending[bufnr] = nil, nil
            end,
          })
        end,
      },
    }
  end,
}
