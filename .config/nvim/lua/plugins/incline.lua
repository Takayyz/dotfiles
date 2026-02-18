-- Floating statusline for each window
-- https://github.com/b0o/incline.nvim
return {
  "b0o/incline.nvim",
  event = "VeryLazy",
  config = function()
    require("incline").setup()
  end,
}
