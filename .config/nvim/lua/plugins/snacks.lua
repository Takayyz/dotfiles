return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    ------------------------------------
    -- Dashboard (GitHub preset)
    ------------------------------------
    dashboard = {
      enabled = true,
      preset = {
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        {
          pane = 2,
          icon = " ",
          desc = "Browse Repo",
          padding = 1,
          key = "b",
          action = function()
            Snacks.gitbrowse()
          end,
        },
        function()
          local in_git = Snacks.git.get_root() ~= nil
          local cmds = {
            {
              title = "Notifications",
              cmd = "gh notify -s -a -n5",
              action = function()
                vim.ui.open("https://github.com/notifications")
              end,
              key = "N",
              icon = " ",
              height = 5,
              enabled = true,
            },
            {
              title = "Open Issues",
              cmd = "gh issue list -L 3",
              key = "i",
              action = function()
                vim.fn.jobstart("gh issue list --web", { detach = true })
              end,
              icon = " ",
              height = 7,
            },
            {
              icon = " ",
              title = "Open PRs",
              cmd = "gh pr list -L 3",
              key = "P",
              action = function()
                vim.fn.jobstart("gh pr list --web", { detach = true })
              end,
              height = 7,
            },
            {
              icon = " ",
              title = "Git Status",
              cmd = "git --no-pager diff --stat -B -M -C",
              height = 10,
            },
          }
          return vim.tbl_map(function(cmd)
            return vim.tbl_extend("force", {
              pane = 2,
              section = "terminal",
              enabled = in_git,
              padding = 1,
              ttl = 5 * 60,
              indent = 3,
            }, cmd)
          end, cmds)
        end,
        { section = "startup" },
      },
    },

    ------------------------------------
    -- Picker
    ------------------------------------
    picker = {
      enabled = true,
      prompt = " ",
      layout = {
        cycle = true,
        preset = function()
          return vim.o.columns >= 120 and "default" or "vertical"
        end,
      },
      matcher = {
        fuzzy = true,
        smartcase = true,
        ignorecase = true,
        filename_bonus = true,
        frecency = true,
      },
      ui_select = true,
      sources = {
        files = {
          hidden = true,
        },
      },
    },

    ------------------------------------
    -- Indent guides
    ------------------------------------
    indent = {
      enabled = true,
      indent = {
        char = "│",
        only_scope = false,
        only_current = false,
      },
      scope = {
        enabled = true,
        underline = false,
      },
      animate = {
        enabled = true,
        style = "out",
      },
    },

    ------------------------------------
    -- Toggle
    ------------------------------------
    toggle = { enabled = true },
  },

  keys = {
    ------------------------------------
    -- Top-level pickers
    ------------------------------------
    { "<leader>?", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
    { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },

    ------------------------------------
    -- Find  (<leader>f)
    ------------------------------------
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent Files" },

    ------------------------------------
    -- Git  (<leader>g)
    ------------------------------------
    { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
    { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
    { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
    { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
    { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
    { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },

    ------------------------------------
    -- Search  (<leader>s)
    ------------------------------------
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
    { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
    { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
    { "<leader>s/", function() Snacks.picker.search_history() end, desc = "Search History" },
    { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
    { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
    { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
    { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
    { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
    { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
    { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
    { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
    { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
    { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
    { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
    { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
    { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },

    ------------------------------------
    -- LSP
    ------------------------------------
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto Type Definition" },
    { "<leader>j", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    { "<leader>r", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
  },

  init = function()
    local augroup = vim.api.nvim_create_augroup("snacks_custom", { clear = true })

    ------------------------------------
    -- Dashboard: transparent background
    ------------------------------------
    vim.api.nvim_create_autocmd("User", {
      group = augroup,
      pattern = "SnacksDashboardOpened",
      callback = function()
        -- Clear trailing-whitespace match (window-local, persists from initial buffer)
        vim.cmd([[match none]])
      end,
    })

    ------------------------------------
    -- Show dashboard when last buffer is closed
    ------------------------------------
    -- Handle :bd (buffer delete) — show dashboard if no listed buffers remain
    vim.api.nvim_create_autocmd("BufDelete", {
      group = augroup,
      callback = function(ev)
        -- Don't reopen dashboard when dashboard itself is closed
        if vim.bo[ev.buf].filetype == "snacks_dashboard" then return end
        vim.schedule(function()
          local remaining = vim.tbl_filter(function(b)
            return vim.bo[b].buflisted
          end, vim.api.nvim_list_bufs())
          if #remaining == 0 then
            -- Embed in current window (like startup) instead of creating a float
            pcall(Snacks.dashboard, { buf = 0, win = 0 })
          end
        end)
      end,
    })

    -- Handle :q on last window — show dashboard instead of quitting
    vim.api.nvim_create_autocmd("QuitPre", {
      group = augroup,
      nested = true,
      callback = function()
        -- Count non-floating windows
        local non_float_wins = vim.tbl_filter(function(w)
          return vim.api.nvim_win_get_config(w).relative == ""
        end, vim.api.nvim_list_wins())
        if #non_float_wins > 1 then return end

        -- Allow quitting from dashboard
        if vim.bo.filetype == "snacks_dashboard" then return end

        -- Open a split with embedded dashboard so :q only closes the original window
        local current_win = vim.api.nvim_get_current_win()
        vim.cmd("new")
        Snacks.dashboard({ buf = 0, win = 0 })
        vim.api.nvim_set_current_win(current_win)
      end,
    })

    ------------------------------------
    -- Toggle keymaps  (<leader>u)
    ------------------------------------
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      group = augroup,
      callback = function()
        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.line_number():map("<leader>ul")
        Snacks.toggle.treesitter():map("<leader>uT")
        Snacks.toggle.inlay_hints():map("<leader>uh")
        Snacks.toggle.indent():map("<leader>ug")
        Snacks.toggle.option("conceallevel", {
          off = 0,
          on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2,
        }):map("<leader>uc")
        Snacks.toggle.option("background", {
          off = "light",
          on = "dark",
          name = "Dark Background",
        }):map("<leader>ub")
      end,
    })
  end,
}
