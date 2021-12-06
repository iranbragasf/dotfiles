local M = {}

M.config = function()
    require("lsp_signature").setup({
        bind = true, -- This is mandatory, otherwise border config won't get registered.
        handler_opts = { border = vim.g.border },
        hint_enable = false
    })
end

return M
