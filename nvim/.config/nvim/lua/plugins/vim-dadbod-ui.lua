local M = {}

M.setup = function()
    vim.g.db_ui_execute_on_save = 0
    vim.g.db_ui_show_database_icon = 1
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_winwidth = 30

    vim.api.nvim_set_keymap("n", "<Leader>db", ":DBUIToggle<CR>", {noremap = true, silent = true})
end

return M
