local extend_vimgrep_arguments = function(vimgrep_arguments)
    local extended_vimgrep_arguments = vim.deepcopy(vimgrep_arguments)
    local vimgrep_extra_arguments = {
        "--trim",
        "--hidden",
        "--follow",
        "--no-ignore",
    }
    for _, pattern in pairs(vim.g.ignore_patterns) do
        table.insert(vimgrep_extra_arguments, "--glob=!" .. pattern)
    end
    for _, extra_argument in pairs(vimgrep_extra_arguments) do
        table.insert(extended_vimgrep_arguments, extra_argument)
    end
    return extended_vimgrep_arguments
end

return {
    {
        "nvim-telescope/telescope.nvim",
        event = "VimEnter",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            "nvim-tree/nvim-web-devicons",
            "neovim/nvim-lspconfig", -- NOTE: must be loaded fist to have some keymaps overriden.
        },
        config = function()
            local telescope = require("telescope")
            local actions_layout = require("telescope.actions.layout")
            local builtin = require("telescope.builtin")
            local config = require("telescope.config")
            local actions = require("telescope.actions")

            local vimgrep_arguments =
                { unpack(config.values.vimgrep_arguments) }
            local extended_vimgrep_arguments =
                extend_vimgrep_arguments(vimgrep_arguments)

            telescope.setup({
                defaults = {
                    sorting_strategy = "ascending",
                    layout_config = {
                        prompt_position = "top",
                    },
                    vimgrep_arguments = extended_vimgrep_arguments,
                    mappings = {
                        i = {
                            ["<Esc>"] = actions.close,
                            ["<C-s>"] = actions.select_horizontal,
                            ["<C-b>"] = actions.preview_scrolling_up,
                            ["<C-f>"] = actions.preview_scrolling_down,
                            ["<M-p>"] = actions_layout.toggle_preview,
                            ["<C-a>"] = actions.toggle_all,
                        },
                    },
                },
                pickers = {
                    find_files = {
                        find_command = {
                            "rg",
                            "--files",
                            "--hidden",
                            "--follow",
                            "--no-ignore",
                            "--glob=!**/{.git,node_modules}/**",
                        },
                    },
                    buffers = {
                        mappings = {
                            i = {
                                ["<C-d>"] = actions.delete_buffer,
                            },
                        },
                    },
                },
            })

            telescope.load_extension("fzf")

            vim.keymap.set("n", "<C-p>", builtin.find_files, { noremap = true })
            vim.keymap.set(
                "n",
                "<Leader>f",
                builtin.live_grep,
                { noremap = true }
            )
            vim.keymap.set(
                "n",
                "<Leader>b",
                builtin.buffers,
                { noremap = true }
            )
            vim.keymap.set(
                "n",
                "<Leader>h",
                builtin.help_tags,
                { noremap = true }
            )
            vim.keymap.set("n", "<Leader>rc", function()
                builtin.find_files({
                    prompt_title = "Dotfiles",
                    cwd = "$HOME/personal/dotfiles",
                })
            end, { noremap = true })
            vim.keymap.set(
                "n",
                "<Leader>m",
                builtin.diagnostics,
                { noremap = true }
            )

            vim.api.nvim_create_user_command(
                "Command",
                builtin.commands,
                { nargs = 0 }
            )
            vim.api.nvim_create_user_command(
                "Keymap",
                builtin.keymaps,
                { nargs = 0 }
            )

            -- NOTE: overrides keymaps defined in `lspconfig` module.
            vim.api.nvim_create_autocmd("LspAttach", {
                group = "lsp-attach",
                callback = function(event)
                    vim.keymap.set(
                        "n",
                        "gr",
                        builtin.lsp_references,
                        { buffer = event.buf }
                    )
                    vim.keymap.set(
                        "n",
                        "gi",
                        builtin.lsp_implementations,
                        { buffer = event.buf }
                    )
                    vim.keymap.set(
                        "n",
                        "gd",
                        builtin.lsp_definitions,
                        { buffer = event.buf }
                    )
                    vim.keymap.set(
                        "n",
                        "<Leader>o",
                        builtin.lsp_document_symbols,
                        { buffer = event.buf }
                    )
                    vim.keymap.set(
                        "n",
                        "gy",
                        builtin.lsp_type_definitions,
                        { buffer = event.buf }
                    )
                end,
            })
        end,
    },
}
