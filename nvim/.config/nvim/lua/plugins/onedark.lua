local M = {}

M.config =  function()
    local ok, onedark = pcall(require, "onedark")
    if not ok then
        vim.notify("[ERROR] onedark not loaded", vim.log.levels.ERROR)
        return
    end

    onedark.setup({
        functionStyle = "italic",
        sidebars = { "qf", "undotree", "dbui" },
        colors = { bg_highlight = "#31353f" }
    })

    vim.cmd([[colorscheme onedark]])
end

return M
