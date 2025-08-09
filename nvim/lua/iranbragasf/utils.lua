local M = {}

--- @param name string The name of the group.
--- @param opts vim.api.keyset.create_augroup? Dict Parameters.
--- @return integer # ID of the created group.
M.create_augroup = function(name, opts)
    opts = opts or { clear = true }
    return vim.api.nvim_create_augroup("iranbragasf." .. name, opts)
end

return M
