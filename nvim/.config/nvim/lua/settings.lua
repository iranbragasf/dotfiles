vim.opt.path:append({"**"})
vim.opt.wildignore:append({
    "**/.git/**",
    "**/node_modules/**",
    "**/coverage/**",
    "**/__pycache__/**",
    "*.o"
})
vim.opt.wildignorecase = true
vim.opt.updatetime = 250
vim.opt.mouse = "a"
vim.opt.guicursor = "n-v-c-sm:block,i-ve:ver25,r-o:hor20"
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
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
vim.opt.foldlevelstart = 99
vim.opt.signcolumn = "yes"
vim.opt.wrap = false

local yank_highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    group = yank_highlight_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank()
    end,
})

local cursorline_in_active_window_group = vim.api.nvim_create_augroup('CursorLineInActiveWindow', { clear = true })
vim.api.nvim_create_autocmd({ 'VimEnter', 'WinEnter', 'BufWinEnter' }, {
    group = cursorline_in_active_window_group,
    pattern = '*',
    callback = function()
        vim.o.cursorline = true
    end,
})
vim.api.nvim_create_autocmd("WinLeave", {
    group = cursorline_in_active_window_group,
    pattern = '*',
    callback = function()
        if vim.bo.filetype ~= "NvimTree" then
            vim.o.cursorline = false
        end
    end,
})

local filetype_detect_group = vim.api.nvim_create_augroup('FiletypeDetect', { clear = true })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    group = filetype_detect_group,
    pattern = 'tsconfig*.json,.eslintrc.json',
    callback = function()
        vim.bo.filetype = "jsonc"
    end,
})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    group = filetype_detect_group,
    pattern = '.env.*',
    callback = function()
        vim.bo.filetype = "sh"
    end,
})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    group = filetype_detect_group,
    pattern = 'config.devmagic,config.titan',
    callback = function()
        vim.bo.filetype = "gitconfig"
    end,
})
