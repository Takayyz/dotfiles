-----------------------------------
-- Appearance
-----------------------------------
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.cmdheight = 0
vim.opt.wrap = false
vim.opt.list = true
vim.opt.listchars = "tab:│─,trail:_,extends:»,precedes:«,nbsp:･"
-- highlight trailing whitespace
local palette = require("config.palette")
vim.api.nvim_set_hl(0, "TrailingWhitespace", { bg = palette.red })
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = vim.api.nvim_create_augroup("TrailingWhitespace", { clear = true }),
  callback = function()
    if vim.bo.buftype == "" then
      vim.cmd([[match TrailingWhitespace /\s\+$/]])
    end
  end,
})
-- clear statusline
vim.opt.laststatus = 0
vim.opt.statusline = "─"
vim.opt.fillchars:append({ stl = "─", stlnc = "─" })

-----------------------------------
-- Indent
-----------------------------------
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.smartindent = true
-- Filetype-specific overrides
vim.api.nvim_create_autocmd("FileType", {
  pattern = "make",
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 0
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "php",
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
  end,
})

-----------------------------------
-- Completion
-----------------------------------
vim.opt.completeopt = "menu,menuone,noinsert"

-----------------------------------
-- Search
-----------------------------------
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true

-----------------------------------
-- Clipboard
-----------------------------------
if vim.fn.has("unnamedplus") == 1 then
  vim.opt.clipboard = "unnamed,unnamedplus"
else
  vim.opt.clipboard = "unnamed"
end
