return {
  "cocopon/iceberg.vim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd("colorscheme iceberg")

    -- Enable transparent background (inherits Ghostty's background-opacity)
    local transparent_groups = {
      "Normal",
      "NormalNC",
      "NormalFloat",
      "FloatBorder",
      "FloatTitle",
      "NonText",
      "SignColumn",
      "EndOfBuffer",
      "LineNr",
      "CursorLineNr",
      "FoldColumn",
    }
    for _, group in ipairs(transparent_groups) do
      local hl = vim.api.nvim_get_hl(0, { name = group })
      hl.bg = nil
      vim.api.nvim_set_hl(0, group, hl)
    end

    -- nvim-notify: iceberg-themed notification colors
    local palette = require("config.palette")
    local notify_levels = {
      ERROR = palette.red,
      WARN  = palette.orange,
      INFO  = palette.green,
      DEBUG = palette.purple,
      TRACE = palette.cyan,
    }
    for level, color in pairs(notify_levels) do
      vim.api.nvim_set_hl(0, "Notify" .. level .. "Border", { fg = color })
      vim.api.nvim_set_hl(0, "Notify" .. level .. "Icon",   { fg = color })
      vim.api.nvim_set_hl(0, "Notify" .. level .. "Title",  { fg = color })
    end
    vim.api.nvim_set_hl(0, "NotifyBackground", { bg = palette.bg })
  end,
}
