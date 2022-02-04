-- This must be set early, otherwise if there are any mappings set BEFORE doing
-- this, they will be set to the DEFAULT leader key.
-- Set `<Space>` as `<Leader>` and `<LocalLeader>` keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Centralize search results on screen
vim.api.nvim_set_keymap("n", "n", "nzz", {noremap = true})
vim.api.nvim_set_keymap("n", "N", "Nzz", {noremap = true})
vim.api.nvim_set_keymap("n", "*", "*zz", {noremap = true})
vim.api.nvim_set_keymap("n", "#", "#zz", {noremap = true})

vim.api.nvim_set_keymap("n", "<Esc>", ":nohlsearch<CR>", {noremap = true, silent = true})

-- TODO: make this work in Visual Block, then remap it to `p`
-- Replace the selected text with the yanked text while keeping the yanked
-- content intact
vim.api.nvim_set_keymap("v", "<Leader>p", '"_dP', {noremap = true})

-- Move text up and down
vim.api.nvim_set_keymap("n", "<A-j>", ":m .+1<CR>==", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<A-k>", ":m .-2<CR>==", {noremap = true, silent = true})
vim.api.nvim_set_keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", {noremap = true, silent = true})
vim.api.nvim_set_keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", {noremap = true, silent = true})

vim.api.nvim_set_keymap("n", "<C-Up>", ":resize +5<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<C-Down>", ":resize -5<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<C-Left>", ":vertical resize +5<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<C-Right>", ":vertical resize -5<CR>", {noremap = true, silent = true})

vim.api.nvim_set_keymap("n", "<C-t>", ":tabnew<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<C-l>", ":tabnext<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<C-h>", ":tabprev<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<C-PageUp>", ":tabmove -1<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<C-PageDown>", ":tabmove +1<CR>", {noremap = true, silent = true})

-- <Left> and <Right> to move the cursor instead of selecting a different match
-- in command-line completion
vim.api.nvim_set_keymap("c", "<Left>", "<Space><BS><Left>", {noremap = true})
vim.api.nvim_set_keymap("c", "<Right>", "<Space><BS><Right>", {noremap = true})

-- Replace word below the cursor in the file
vim.api.nvim_set_keymap("n", "<Leader>rw", ":%s/<C-r><C-w>//g<Left><Left>", {noremap = true})
-- Replace highlighted words in the file
vim.api.nvim_set_keymap("v", "<Leader>rw", 'y:%s/<C-r><C-r>"//g<Left><Left>', {noremap = true})

-- QuickFix List navigation
-- TODO: enhance quickfix list toggle function, see:
-- https://rafaelleru.github.io/blog/quickfix-autocomands/ and
-- https://vim.fandom.com/wiki/Toggle_to_open_or_close_the_quickfix_window
is_qf_list_open = 0
function toggle_qf_list()
    if is_qf_list_open == 1 then
        is_qf_list_open = 0
        vim.api.nvim_command("cclose")
    else
        is_qf_list_open = 1
        vim.api.nvim_command("copen")
    end
end
vim.api.nvim_set_keymap("n", "<C-q>", "<Cmd>lua toggle_qf_list()<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "]q", ":cnext<CR>zz", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "[q", ":cprev<CR>zz", {noremap = true, silent = true})
