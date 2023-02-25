local M = {}

M.config =  function()
    local ok, tokyonight = pcall(require, "tokyonight")
    if not ok then
        vim.notify("[ERROR] tokyonight not loaded", vim.log.levels.ERROR)
        return
    end

    vim.cmd.colorscheme("tokyonight")
end

return M
