local M = {}

--- @param name string String: The name of the group
--- @param opts vim.api.keyset.create_augroup Dict Parameters
--- - clear (bool) optional: defaults to true. Clear existing
--- commands if the group already exists `autocmd-groups`.
--- @return integer # Integer ID of the created group.
M.create_augroup = function(name, opts)
    opts = opts or {}
    return vim.api.nvim_create_augroup("iranbragasf-" .. name, opts)
end

return M
