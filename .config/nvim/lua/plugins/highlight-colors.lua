-- Highlight color codes inline (hex, rgb, hsl, named, tailwind)
-- https://github.com/brenoprata10/nvim-highlight-colors
return {
  "brenoprata10/nvim-highlight-colors",
  event = "BufReadPre",
  opts = {
    render = "virtual",
    virtual_symbol = "●",
    virtual_symbol_position = "eow",
    enable_named_colors = false,
    enable_tailwind = true,
  },
}
