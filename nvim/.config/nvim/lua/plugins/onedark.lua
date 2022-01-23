local M = {}

M.config =  function()
    require('onedark').setup({
        functionStyle = "italic",
        sidebars = { "qf", "undotree", "dbui" },
        colors = { bg_highlight = "#31353f" }
    })

    vim.cmd([[colorscheme onedark]])
end

return M
