-- NOTE: bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        lazyrepo,
        lazypath,
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

vim.api.nvim_create_autocmd("FileType", {
    pattern = "lazy",
    callback = function()
        vim.opt_local.cursorline = true
    end,
})

require("lazy").setup({
    spec = {
        { import = "iranbragasf.plugins" },
    },
    install = {
        colorscheme = { vim.g.colors_name },
    },
    checker = {
        enabled = true,
        notify = false,
    },
    change_detection = { notify = false },
})
