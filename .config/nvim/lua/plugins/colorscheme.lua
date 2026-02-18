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
  end,
}
