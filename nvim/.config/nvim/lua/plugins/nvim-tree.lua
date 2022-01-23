local M = {}

M.setup = function()
    vim.g.nvim_tree_git_hl = 1
    vim.g.nvim_tree_group_empty = 1
    vim.g.nvim_tree_root_folder_modifier = ':t'
    vim.g.nvim_tree_create_in_closed_folder = 1
    vim.g.nvim_tree_window_picker_exclude = {
        filetype = { 'packer', 'qf', 'dbui', 'undotree' },
        buftype = { 'terminal' }
    }
    vim.g.nvim_tree_special_files = {}
    vim.g.nvim_tree_icons = {
        default = "",
        symlink = "",
        git = {
            unstaged  = "M",
            staged    = "M",
            unmerged  = "!",
            renamed   = "R",
            untracked = "U",
            deleted   = "D",
            ignored   = ""
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
        diagnostics = {
            enable = true,
            icons = {
              error = "",
              warning = "",
              hint = "",
              info = ""
            }
        },
        view = {
            auto_resize = true,
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

    -- Workaround to highlight items that are ignored by git since it isn't
    -- possible with `git.ignore` set to `false`
    require('nvim-tree.lib').toggle_ignored()
end

return M
