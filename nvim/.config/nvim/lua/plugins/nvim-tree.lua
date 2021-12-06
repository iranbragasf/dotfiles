local M = {}

M.setup = function()
    vim.g.nvim_tree_git_hl = 1
    vim.g.nvim_tree_group_empty = 1
    vim.g.nvim_tree_root_folder_modifier = ':t'
    vim.g.nvim_tree_window_picker_exclude = {
        filetype = { 'packer', 'qf' },
        buftype = { 'terminal' }
    }
    vim.g.nvim_tree_icons = {
        git = {
            unstaged  = "M",
            staged    = "M",
            unmerged  = "M",
            renamed   = "R",
            untracked = "U",
            deleted   = "D"
        }
    }

    vim.api.nvim_set_keymap("n", "<C-b>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
end

M.config = function()
    local tree_cb = require('nvim-tree.config').nvim_tree_callback

    require('nvim-tree').setup({
        auto_close = true,
        update_focused_file = { enable = true },
        update_cwd = true,
        git = {
            ignore = false,
            timeout = 500
        },
        view = {
            mappings = {
                list = {
                    { key = "l",     cb = tree_cb("edit") },
                    { key = "h",     cb = tree_cb("close_node") },
                    { key = "<C-s>", cb = tree_cb("split") },
                    { key = "L",     cb = tree_cb("cd") },
                    { key = "H",     cb = tree_cb("dir_up") },
                    { key = "?",     cb = tree_cb("toggle_help") },
                    { key = "o",     cb = tree_cb("system_open") }
                }
            }
        }
    })
end

return M
