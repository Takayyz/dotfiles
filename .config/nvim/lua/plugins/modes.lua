-- Highlight cursorline & line number by current mode
-- https://github.com/mvllow/modes.nvim
return {
  "mvllow/modes.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local palette = require("config.palette")
    require("modes").setup({
      colors = {
        copy = palette.orange,
        delete = palette.red,
        insert = palette.blue,
        visual = palette.purple,
      },
      line_opacity = 0.4,
      set_cursor = true,
      set_cursorline = true,
      set_number = true,
    })
  end,
}
