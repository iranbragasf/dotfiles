vim.g.have_nerd_font = true

vim.opt.colorcolumn = "80"
vim.opt.path:append({ "**" })
vim.opt.wildignore:append({ "**/.git/**", "**/node_modules/**" })
vim.opt.wildignorecase = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.mouse = "a"
vim.opt.guicursor = ""
-- NOTE: schedule the setting after `UiEnter` because it can increase
-- startup-time.
vim.schedule(function()
	vim.opt.clipboard:append("unnamedplus")
end)
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "split"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
-- NOTE: enable `breakindent` and `linebreak` just in case some window has
-- `wrap` on.
vim.opt.breakindent = true
vim.opt.linebreak = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.signcolumn = "yes"
vim.opt.completeopt = { "menuone", "noinsert", "noselect" }
vim.opt.shortmess:append({ c = true })
vim.opt.cursorline = true
vim.opt.pumheight = 12
vim.opt.list = true
vim.opt.listchars = {
	tab = "» ",
	trail = "·",
	nbsp = "␣",
    eol = "↵",
}
vim.opt.winborder = "none"
vim.cmd.colorscheme("habamax")

vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = "*",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function() vim.hl.on_yank() end,
})

vim.api.nvim_create_autocmd("VimResized", {
	pattern = "*",
	group = vim.api.nvim_create_augroup("resize-windows", { clear = true }),
	callback = function() vim.cmd.tabdo("wincmd =") end,
})

vim.api.nvim_create_augroup("filetype-detect", { clear = true })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	group = "filetype-detect",
	pattern = { "tsconfig*.json", ".eslintrc.json" },
	callback = function() vim.opt_local.filetype = "jsonc" end,
})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	group = "filetype-detect",
	pattern = ".env.*",
	callback = function() vim.opt_local.filetype = "sh" end,
})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	group = "filetype-detect",
	pattern = "*/git/config*",
	callback = function() vim.opt_local.filetype = "gitconfig" end,
})

vim.g.mapleader = " "
vim.g.maplocalleader = " "

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
-- TODO: toggle quickfix and location lists and open them in the current
-- window, whether there're more windows open
vim.keymap.set("n", "<C-q>", ":copen<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "]q", ":cnext<CR>zz", { noremap = true, silent = true })
vim.keymap.set("n", "[q", ":cprev<CR>zz", { noremap = true, silent = true })
vim.keymap.set("n", "<M-q>", ":lopen<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "]l", ":lnext<CR>zz", { noremap = true, silent = true })
vim.keymap.set("n", "[l", ":lprev<CR>zz", { noremap = true, silent = true })
