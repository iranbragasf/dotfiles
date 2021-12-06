vim.opt.path:append({"**"})
vim.opt.wildignore:append({
    "**/.git/**",
    "**/node_modules/**",
    "**/coverage/**",
    "**/__pycache__/**",
    "*.o"
})
vim.opt.hidden = true
vim.opt.updatetime = 250
vim.opt.mouse = "a"
vim.opt.guicursor = "i-ve:ver25"
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5
vim.opt.colorcolumn = "80"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"
vim.opt.foldmethod = "indent"
vim.opt.foldlevelstart = 99
vim.opt.signcolumn = "yes"
vim.opt.wrap = false

-- Custom global variable to standardize borders through config.
-- See `:h nvim_open_win` for available options.
vim.g.border = "rounded"

vim.cmd([[
    augroup highlight_yank
        autocmd!
        autocmd TextYankPost * silent! lua vim.highlight.on_yank({ higroup="IncSearch", timeout=700 })
    augroup END
]])

-- Highlight current line, but only in active window (unless it's NvimTree)
vim.cmd([[
    augroup cursor_line_only_in_active_window
        autocmd!
        autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
        autocmd WinLeave * if &ft!~?"NvimTree" | setlocal nocursorline | endif
    augroup END
]])

vim.cmd([[
    augroup filetypedetect
        autocmd!
        autocmd BufNewFile,BufRead tsconfig.json setlocal ft=jsonc
        autocmd BufNewFile,BufRead .env.* setlocal ft=sh
    augroup END
]])
