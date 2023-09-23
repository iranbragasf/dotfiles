local M = {}

M.config = function()
    local ok, treesitter = pcall(require, "nvim-treesitter.configs")
    if not ok then
        vim.notify("[ERROR] nvim-treesitter not loaded", vim.log.levels.ERROR)
        return
    end

    treesitter.setup({
        ensure_installed = { "javascript", "typescript", "html", "css", "json", "jsonc"  },
        sync_install = false,
        auto_install = true,
        highlight = { enable = true },
        context_commentstring = {
            enable = true,
            enable_autocmd = false
        }
    })

    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    vim.opt.foldenable = false
    vim.opt.foldlevel = 99
end

return M
