vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local map = vim.keymap.set

-----------------------------------
-- Insert mode
-----------------------------------
map("i", "jj", "<Esc>", { desc = "Escape" })
map("i", "<S-Tab>", "<C-d>", { desc = "Dedent" })

-----------------------------------
-- Normal mode
-----------------------------------
map("n", "<Esc><Esc>", "<Cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
map("n", "<Leader>w", "<Cmd>w<CR>", { desc = "Save" })
map("n", "<Leader>q", "<Cmd>q<CR>", { desc = "Quit" })
map("n", "<Leader>h", "^", { desc = "Go to beginning of line" })
map("n", "<Leader>l", "$", { desc = "Go to end of line" })
map("n", "<Leader>c", "gcc", { remap = true, desc = "Toggle comment" })
map("n", "<Leader><", "<<", { desc = "Dedent line" })
map("n", "<Leader>>", ">>", { desc = "Indent line" })
map("n", "<Leader>-", "<Cmd>split<CR>", { desc = "Split pane horizontally" })
map("n", "<Leader>\\", "<Cmd>vsplit<CR>", { desc = "Split pane vertically" })
map("n", "gg", "gg0", { desc = "Go to first character of file" })
map("n", "<Leader>n", "<Cmd>enew<CR>", { desc = "New file" })
map("n", "<Leader>t", "<Cmd>tabnew<CR>", { desc = "New tab" })
map("n", "<Leader><Tab>", "<Cmd>tabnext<CR>", { desc = "Next tab" })
map("n", "<Leader><S-Tab>", "<Cmd>tabprevious<CR>", { desc = "Previous tab" })
map("n", "<Leader>yp", function()
  local absolute = vim.fn.expand("%:p")
  local git_root = vim.fn.systemlist("git -C " .. vim.fn.shellescape(vim.fn.expand("%:p:h")) .. " rev-parse --show-toplevel")[1]
  if vim.v.shell_error ~= 0 then
    -- git repo でなければ CWD 相対にフォールバック
    local path = vim.fn.expand("%:.")
    vim.fn.setreg("+", path)
    vim.notify(path, vim.log.levels.INFO, { title = "Copied path (cwd-relative)" })
    return
  end
  local relative = absolute:sub(#git_root + 2)
  vim.fn.setreg("+", relative)
  vim.notify(relative, vim.log.levels.INFO, { title = "Copied path" })
end, { desc = "Copy git-relative file path" })

-----------------------------------
-- Visual mode
-----------------------------------
map("v", "<Leader>c", "gc", { remap = true, desc = "Toggle comment" })
map("v", "<Leader><", "<gv", { desc = "Dedent and keep selection" })
map("v", "<Leader>>", ">gv", { desc = "Indent and keep selection" })
