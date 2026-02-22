-- Floating statusline for each window
-- https://github.com/b0o/incline.nvim
return {
  "b0o/incline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  config = function()
    local devicons = require("nvim-web-devicons")

    local palette = require("config.palette")
    local fg_inactive = palette.comment
    local fg_dirname = palette.comment

    -- Filenames too generic to identify alone
    local generic_filenames = {
      ["index.js"] = true, ["index.jsx"] = true, ["index.ts"] = true, ["index.tsx"] = true,
      ["index.css"] = true, ["index.scss"] = true, ["index.vue"] = true,
      ["page.tsx"] = true, ["page.ts"] = true, ["page.jsx"] = true, ["page.js"] = true,
      ["layout.tsx"] = true, ["layout.ts"] = true, ["layout.jsx"] = true, ["layout.js"] = true,
      ["route.ts"] = true, ["route.tsx"] = true,
      ["init.lua"] = true, ["mod.rs"] = true, ["lib.rs"] = true, ["main.rs"] = true,
    }

    -- Directory names too generic to be useful as context
    local generic_dirnames = {
      ["src"] = true, ["app"] = true, ["pages"] = true, ["lib"] = true,
      [".storybook"] = true,
    }

    --- Returns (filename, dirname_or_nil) for display
    local function get_display_name(buf)
      local bufname = vim.api.nvim_buf_get_name(buf)
      if bufname == "" then
        return "[No Name]", nil
      end
      local filename = vim.fn.fnamemodify(bufname, ":t")
      if not generic_filenames[filename] then
        return filename, nil
      end
      -- Walk up to 3 parent directories to find a meaningful name
      local parts = {}
      local dir = vim.fn.fnamemodify(bufname, ":h")
      for _ = 1, 3 do
        local dirname = vim.fn.fnamemodify(dir, ":t")
        if dirname == "" or dirname == "." then break end
        table.insert(parts, 1, dirname)
        if not generic_dirnames[dirname] then break end
        dir = vim.fn.fnamemodify(dir, ":h")
      end
      local display_dir = #parts > 0 and table.concat(parts, "/") or nil
      return filename, display_dir
    end

    require("incline").setup({
      window = {
        placement = {
          horizontal = "left",
          vertical = "bottom",
        },
      },
      render = function(props)
        local filename, dirname = get_display_name(props.buf)
        local ft_icon, ft_color = devicons.get_icon_color(filename)

        -- Diagnostics (Nerd Font icons via Unicode codepoints)
        local diag_icons = {
          error = vim.fn.nr2char(0xf06a),  -- nf-fa-exclamation_circle
          warn  = vim.fn.nr2char(0xf071),  -- nf-fa-exclamation_triangle
          info  = vim.fn.nr2char(0xf05a),  -- nf-fa-info_circle
          hint  = vim.fn.nr2char(0xf0eb),  -- nf-fa-lightbulb_o
        }
        local label = {}
        for severity, icon in pairs(diag_icons) do
          local n = #vim.diagnostic.get(props.buf, {
            severity = vim.diagnostic.severity[string.upper(severity)],
          })
          if n > 0 then
            local color = fg_inactive
            if props.focused then
              local hl = vim.api.nvim_get_hl(0, { name = "DiagnosticSign" .. severity })
              color = hl.fg and string.format("#%06x", hl.fg) or color
            end
            table.insert(label, { icon .. " " .. n .. " ", guifg = color })
          end
        end
        if #label > 0 then
          table.insert(label, { "┊ " })
        end

        local result = {
          { label },
          { (ft_icon or "") .. " ", guifg = props.focused and ft_color or fg_inactive, guibg = "none" },
        }
        if dirname then
          table.insert(result, { dirname .. "/", guifg = props.focused and fg_dirname or fg_inactive })
        end
        table.insert(result, { filename, gui = props.focused and "bold" or nil, guifg = not props.focused and fg_inactive or nil })
        table.insert(result, { vim.bo[props.buf].modified and " ●" or " ", guifg = props.focused and palette.orange or fg_inactive })
        return result
      end,
    })
  end,
}
