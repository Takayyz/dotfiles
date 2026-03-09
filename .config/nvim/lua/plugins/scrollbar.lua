-- Scrollbar with diagnostic / git markers
-- https://github.com/petertriho/nvim-scrollbar
return {
  "petertriho/nvim-scrollbar",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local palette = require("config.palette")

    require("scrollbar").setup({
      handle = {
        color = palette.comment,
      },
      marks = {
        Error   = { color = palette.red },
        Warn    = { color = palette.orange },
        Info    = { color = palette.blue },
        Hint    = { color = palette.cyan },
        Search  = { color = palette.green },
        GitAdd    = { color = palette.green },
        GitChange = { color = palette.blue },
        GitDelete = { color = palette.red },
      },
      handlers = {
        diagnostic = true,
        search = false,
        gitsigns = true,
      },
    })
  end,
}
