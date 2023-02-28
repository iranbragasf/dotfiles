vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", {noremap = true, silent = true})

vim.keymap.set("v", "<Leader>p", '"_dP', {noremap = true})

vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", {noremap = true, silent = true})
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", {noremap = true, silent = true})
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", {noremap = true, silent = true})
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", {noremap = true, silent = true})

vim.keymap.set("n", "<C-Up>", ":resize +5<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "<C-Down>", ":resize -5<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "<C-Left>", ":vertical resize +5<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "<C-Right>", ":vertical resize -5<CR>", {noremap = true, silent = true})

vim.keymap.set("n", "<C-t>", ":tabnew<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "<C-l>", ":tabnext<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "<C-h>", ":tabprev<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "<C-PageUp>", ":tabmove -1<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "<C-PageDown>", ":tabmove +1<CR>", {noremap = true, silent = true})

vim.keymap.set("n", "<S-h>", ":bprevious<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "<S-l>", ":bnext<CR>", {noremap = true, silent = true})

vim.keymap.set("n", "<Leader>rw", ":%s/<C-r><C-w>//g<Left><Left>", {noremap = true})
vim.keymap.set("v", "<Leader>rw", 'y:%s/<C-r><C-r>"//g<Left><Left>', {noremap = true})

-- Keymaps for better default experience
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', {noremap = true})
vim.keymap.set({ 'n', 'v' }, "J", "mzJ`z")
vim.keymap.set({ 'n', 'v' }, "<C-d>", "<C-d>zz")
vim.keymap.set({ 'n', 'v' }, "<C-u>", "<C-u>zz")
vim.keymap.set({ 'n', 'v' }, "n", "nzz", {noremap = true})
vim.keymap.set({ 'n', 'v' }, "N", "Nzz", {noremap = true})
vim.keymap.set("n", "*", "*zz", {noremap = true})
vim.keymap.set("n", "#", "#zz", {noremap = true})
vim.keymap.set("c", "<Left>", "<Space><BS><Left>", {noremap = true})
vim.keymap.set("c", "<Right>", "<Space><BS><Right>", {noremap = true})
vim.keymap.set("v", "<", "<gv", {noremap = true})
vim.keymap.set("v", ">", ">gv", {noremap = true})

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", {noremap = true})

local is_qf_list_open = false
vim.api.nvim_create_augroup('FixLists', { clear = true })
vim.api.nvim_create_autocmd('BufWinEnter', {
    group = "FixLists",
    pattern = 'quickfix',
    callback = function() is_qf_list_open = true end,
})
vim.api.nvim_create_autocmd('BufWinLeave', {
    group = "FixLists",
    pattern = '*',
    callback = function() is_qf_list_open = false end,
})
local toggle_qf_list = function()
    if is_qf_list_open == true then
        vim.cmd.cclose()
        return
    end

    vim.cmd.copen()
end
vim.keymap.set("n", "<C-q>", toggle_qf_list, {noremap = true})
vim.keymap.set("n", "]q", ":cnext<CR>zz", {noremap = true, silent = true})
vim.keymap.set("n", "[q", ":cprev<CR>zz", {noremap = true, silent = true})
