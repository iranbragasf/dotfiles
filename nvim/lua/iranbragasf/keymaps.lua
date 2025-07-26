vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- NOTE: improve default keymaps.
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { noremap = true })
vim.keymap.set({ "n", "v" }, "<C-d>", "<C-d>zz", { noremap = true })
vim.keymap.set({ "n", "v" }, "<C-u>", "<C-u>zz", { noremap = true })
vim.keymap.set({ "n", "v" }, "<C-f>", "<C-f>zz", { noremap = true })
vim.keymap.set({ "n", "v" }, "<C-b>", "<C-b>zz", { noremap = true })
vim.keymap.set({ "n", "v" }, "n", "nzz", { noremap = true })
vim.keymap.set({ "n", "v" }, "N", "Nzz", { noremap = true })
vim.keymap.set({ "n", "v" }, "*", "*zz", { noremap = true })
vim.keymap.set({ "n", "v" }, "#", "#zz", { noremap = true })
vim.keymap.set({ "n", "v" }, "J", "mzJ`z", { noremap = true })
vim.keymap.set("v", "<", "<gv", { noremap = true })
vim.keymap.set("v", ">", ">gv", { noremap = true })

vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { noremap = true, silent = true })

vim.keymap.set({ "n", "v" }, "<C-Up>", ":resize +2<CR>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<C-Down>", ":resize -2<CR>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<C-Right>", ":vertical resize +2<CR>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<C-Left>", ":vertical resize -2<CR>", { noremap = true, silent = true })

-- TODO: toggle quickfix and location lists
-- vim.keymap.set("n", "<C-q>", ":copen<CR>", { noremap = true, silent = true })
-- vim.keymap.set("n","<C-l>", ":lopen<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<Leader>e", ":Explore<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>rc", ":Explore ~/personal/dotfiles<CR>", { noremap = true, silent = true })
