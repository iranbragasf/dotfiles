local M = {}

M.config = function()
    local ok, lsp_signature = pcall(require, "lsp_signature")
    if not ok then
        vim.notify("ERROR: lsp_signature not loaded", vim.log.levels.ERROR)
        return
    end

    lsp_signature.setup({
        handler_opts = { border = vim.g.border },
        hint_enable = false
    })
end

return M
