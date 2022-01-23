local M = {}

M.config = function()
    require("lsp_signature").setup({
        handler_opts = { border = vim.g.border },
        hint_enable = false
    })
end

return M
