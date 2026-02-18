vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local map = vim.keymap.set

-----------------------------------
-- Insert mode
-----------------------------------
map("i", "jj", "<Esc>", { desc = "Escape" })

-----------------------------------
-- Normal mode
-----------------------------------
map("n", "<Leader>w", "<Cmd>w<CR>", { desc = "Save" })
map("n", "<Leader>q", "<Cmd>q<CR>", { desc = "Quit" })
map("n", "<Leader>h", "^", { desc = "Go to beginning of line" })
map("n", "<Leader>l", "$", { desc = "Go to end of line" })
map("n", "<Leader>c", "gcc", { remap = true, desc = "Toggle comment" })
map("n", "<Leader><", "<<", { desc = "Dedent line" })
map("n", "<Leader>>", ">>", { desc = "Indent line" })

-----------------------------------
-- Visual mode
-----------------------------------
map("v", "<Leader>c", "gc", { remap = true, desc = "Toggle comment" })
map("v", "<Leader><", "<gv", { desc = "Dedent and keep selection" })
map("v", "<Leader>>", ">gv", { desc = "Indent and keep selection" })
