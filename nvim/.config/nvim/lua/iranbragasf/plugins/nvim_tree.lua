local on_attach = function(bufnr)
    local api = require("nvim-tree.api")

    local opts = function(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- default mappings
    api.config.mappings.default_on_attach(bufnr)

    -- custom mappings
    vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
    vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close'))
    vim.keymap.set('n', '<C-s>', api.node.open.horizontal, opts('Open: Horizontal Split'))
    vim.keymap.del('n', '<C-e>', { buffer = bufnr })
end

require("nvim-tree").setup({
    on_attach = on_attach,
    disable_netrw = true,
    sync_root_with_cwd = true,
    view = { signcolumn = "no" },
    renderer = {
        group_empty = true,
        root_folder_label = ":t",
        special_files = {},
        highlight_git = true,
        icons = {
            git_placement = "after",
            diagnostics_placement = "after",
            glyphs = {
                git = {
                    unstaged  = "M",
                    staged    = "A",
                    unmerged  = "!",
                    renamed   = "R",
                    untracked = "U",
                    deleted   = "D",
                    ignored   = ""
                }
            },
        }
    },
    update_focused_file = { enable = true },
    diagnostics = {
        enable = true,
        show_on_dirs = true,
        icons = {
            error = " ",
            warning = " ",
            hint = " ",
            info = " "
        }
    },
    filters = { git_ignored = false },
})

vim.keymap.set("n", "<C-e>", ":NvimTreeToggle<CR>", {noremap = true, silent = true})
