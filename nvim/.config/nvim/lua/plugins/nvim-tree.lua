local M = {}

M.setup = function()
    vim.api.nvim_set_keymap("n", "<C-b>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
end

M.config = function()
    local ok, nvim_tree = pcall(require, "nvim-tree")
    if not ok then
        vim.notify("[ERROR] nvim-tree not loaded", vim.log.levels.ERROR)
        return
    end

    local tree_cb = require('nvim-tree.config').nvim_tree_callback

    nvim_tree.setup({
        create_in_closed_folder = true,
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
        git = { ignore = false },
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
        },
        renderer = {
            group_empty = true,
            root_folder_modifier = ':t',
            icons = {
                webdev_colors = true,
                git_placement = "before",
                padding = " ",
                symlink_arrow = " ➛ ",
                show = {
                    file = true,
                    folder = true,
                    folder_arrow = true,
                    git = true,
                },
                glyphs = {
                    git = {
                        unstaged  = "M",
                        staged    = "M",
                        unmerged  = "!",
                        renamed   = "R",
                        untracked = "U",
                        deleted   = "D",
                        ignored   = ""
                    }
                },
            },
            special_files = {},
        },
        actions = {
            open_file = {
                quit_on_open = false,
                resize_window = true,
                window_picker = {
                    exclude = {
                        filetype = { 'packer', 'qf', 'dbui', 'undotree', "diff" },
                        buftype = { "nofile", "terminal", "help" },
                    },
                },
            },
        }
    })
    end

return M
