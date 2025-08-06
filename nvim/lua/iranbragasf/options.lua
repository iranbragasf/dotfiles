vim.g.editorconfig = true
vim.g.format_on_save = true
vim.g.enable_linting = true
vim.g.enable_inlay_hints = true
vim.g.enable_builtin_autocompletion = false
vim.g.enable_builtin_formatting = false

vim.opt.colorcolumn = "80"
vim.opt.path:append({ "**" })
-- TODO: create a list of globally ignored directories
-- (e.g. vim.g.ignored_dirs = { ".git", "node_modules", "dist" })
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
-- NOTE: `breakindent` and `linebreak` are enabled just in case some window has
-- `wrap` on.
vim.opt.breakindent = true
vim.opt.linebreak = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.signcolumn = "yes"
vim.opt.completeopt = { "menuone", "popup", "noinsert", "fuzzy" }
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
vim.opt.foldmethod = "expr"
vim.opt.foldlevel = 99
vim.opt.winborder = "none"
