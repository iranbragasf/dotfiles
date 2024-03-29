vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false
vim.opt.foldlevel = 99

require("nvim-treesitter.configs").setup({
    ensure_installed = { "lua", "javascript", "typescript", "json", "jsonc" },
    sync_install = false,
    auto_install = true,
    highlight = { enable = true },
    context_commentstring = { enable = true }
})
