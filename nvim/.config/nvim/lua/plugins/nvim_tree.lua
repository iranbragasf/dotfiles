local M = {}

M.init = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    vim.keymap.set("n", "<C-b>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
end

M.config = function()
    local nvim_tree_ok, nvim_tree = pcall(require, "nvim-tree")
    if not nvim_tree_ok then
        vim.notify("[ERROR] nvim-tree not loaded", vim.log.levels.ERROR)
        return
    end

    nvim_tree.setup({
        sync_root_with_cwd = true,
        view = {
            mappings = {
                list = {
                    { key = "l",     action = "edit" },
                    { key = "h",     action = "close_node" },
                    { key = "<C-s>", action = "split" },
                    { key = "L",     action = "cd" },
                    { key = "H",     action = "dir_up" },
                }
            }
        },
        renderer = {
            group_empty = true,
            highlight_git = true,
            root_folder_label = ":t",
            icons = {
                git_placement = "after",
                glyphs = {
                    git = {
                        unstaged = "✗",
                        staged = "✓",
                        unmerged = "",
                        renamed = "➜",
                        untracked = "★",
                        deleted = "",
                        ignored = "◌",
                    },
                    -- git = {
                    --     unstaged  = "M",
                    --     staged    = "M",
                    --     unmerged  = "!",
                    --     renamed   = "R",
                    --     untracked = "U",
                    --     deleted   = "D",
                    --     ignored   = ""
                    -- }
                },
            },
            special_files = {},
        },
        update_focused_file = {
            enable = true,
        },
        git = {
            ignore = false,
        },
        actions = {
            open_file = {
                window_picker = {
                    exclude = {
                        filetype = {
                            "notify",
                            "packer",
                            "qf",
                            "diff",
                            "fugitive",
                            "fugitiveblame",
                            "undotree"
                        },
                    }
                }
            }
        }
    })

    vim.api.nvim_create_autocmd("WinLeave", {
        group = "CursorLineInActiveWindow",
        pattern = '*',
        callback = function()
            local filetype = vim.api.nvim_buf_get_option(0, "filetype")
            if filetype == "NvimTree" then
                vim.api.nvim_win_set_option(0, "cursorline", true)
            end
        end,
    })
end

return M
