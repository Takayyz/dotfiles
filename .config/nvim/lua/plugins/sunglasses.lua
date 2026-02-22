-- Dim inactive windows to visually highlight the focused pane
-- https://github.com/miversen33/sunglasses.nvim
return {
  "miversen33/sunglasses.nvim",
  event = "UIEnter",
  opts = {
    filter_type = "SHADE",
    filter_percent = 0.5,
  },
}
