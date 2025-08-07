vim.g.mapleader = vim.keycode("<Space>")
vim.g.maplocalleader = vim.keycode("<Space>")

vim.keymap.set(
    { "n", "v" },
    "<C-u>",
    "<C-u>zz",
    { noremap = true, desc = "Scroll up and center cursor" }
)
vim.keymap.set(
    { "n", "v" },
    "<C-d>",
    "<C-d>zz",
    { noremap = true, desc = "Scroll down and center cursor" }
)
vim.keymap.set(
    { "n", "v" },
    "<C-b>",
    "<C-b>zz",
    { noremap = true, desc = "Page up and center cursor" }
)
vim.keymap.set(
    { "n", "v" },
    "<C-f>",
    "<C-f>zz",
    { noremap = true, desc = "Page down and center cursor" }
)
vim.keymap.set(
    { "n", "v" },
    "n",
    "nzz",
    { noremap = true, desc = "Next search result centered" }
)
vim.keymap.set(
    { "n", "v" },
    "N",
    "Nzz",
    { noremap = true, desc = "Previous search result centered" }
)
vim.keymap.set(
    { "n", "v" },
    "*",
    "*zz",
    { noremap = true, desc = "Search word under cursor and center it" }
)
vim.keymap.set(
    { "n", "v" },
    "#",
    "#zz",
    { noremap = true, desc = "Search backward word under cursor and center it" }
)
vim.keymap.set(
    "v",
    "<",
    "<gv",
    { noremap = true, desc = "Indent left and keep visual mode" }
)
vim.keymap.set(
    "v",
    ">",
    ">gv",
    { noremap = true, desc = "Indent right and keep visual mode" }
)
vim.keymap.set(
    "n",
    "<Esc>",
    ":nohlsearch<CR>",
    { noremap = true, silent = true, desc = "Clear search highlight" }
)
vim.keymap.set(
    "n",
    "<C-Up>",
    ":resize +2<CR>",
    {
        noremap = true,
        silent = true,
        desc = "Increase window height by 2 lines",
    }
)
vim.keymap.set(
    "n",
    "<C-Down>",
    ":resize -2<CR>",
    {
        noremap = true,
        silent = true,
        desc = "Decrease window height by 2 lines",
    }
)
vim.keymap.set(
    "n",
    "<C-Right>",
    ":vertical resize +2<CR>",
    {
        noremap = true,
        silent = true,
        desc = "Increase window width by 2 columns",
    }
)
vim.keymap.set(
    "n",
    "<C-Left>",
    ":vertical resize -2<CR>",
    {
        noremap = true,
        silent = true,
        desc = "Decrease window width by 2 columns",
    }
)
vim.keymap.set("n", "<Leader>e", ":Explore<CR>", {
    noremap = true,
    silent = true,
    desc = "Open file explorer in current directory",
})
vim.keymap.set("n", "<Leader>rc", ":Explore ~/personal/dotfiles<CR>", {
    noremap = true,
    silent = true,
    desc = "Open file explorer in dotfiles directory",
})
-- TODO: toggle quickfix and location lists
-- vim.keymap.set("n", "<C-q>", ":copen<CR>", { noremap = true, silent = true })
-- vim.keymap.set("n","<C-l>", ":lopen<CR>", { noremap = true, silent = true })
