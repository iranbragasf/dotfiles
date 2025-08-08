local create_augroup = require("iranbragasf.utils").create_augroup

--- @param command_args table<string>
--- @return table<string>
local append_command_args_with_ignore_patterns = function(command_args)
    local extended_command_args = vim.deepcopy(command_args)
    for _, pattern in pairs(vim.g.ignore_patterns) do
        table.insert(extended_command_args, "--glob=!" .. pattern)
    end
    return extended_command_args
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

            local vimgrep_args = { unpack(config.values.vimgrep_arguments) }
            local vimgrep_extra_args = {
                "--trim",
                "--hidden",
                "--follow",
                "--no-ignore",
            }
            for _, arg in pairs(vimgrep_extra_args) do
                table.insert(vimgrep_args, arg)
            end
            local vimgrep_args_with_ignore_patterns =
                append_command_args_with_ignore_patterns(vimgrep_args)

            local find_command = {
                "rg",
                "--files",
                "--hidden",
                "--follow",
                "--no-ignore",
            }
            local find_command_with_ignore_patterns =
                append_command_args_with_ignore_patterns(find_command)

            telescope.setup({
                defaults = {
                    sorting_strategy = "ascending",
                    layout_config = {
                        prompt_position = "top",
                    },
                    vimgrep_arguments = vimgrep_args_with_ignore_patterns,
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
                        find_command = find_command_with_ignore_patterns,
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

            vim.keymap.set(
                "n",
                "<C-p>",
                builtin.find_files,
                { noremap = true, desc = "Find files" }
            )
            vim.keymap.set(
                "n",
                "<Leader>f",
                builtin.live_grep,
                { noremap = true, desc = "Search text in project" }
            )
            vim.keymap.set(
                "n",
                "<Leader>b",
                builtin.buffers,
                { noremap = true, desc = "List open buffers" }
            )
            vim.keymap.set(
                "n",
                "<Leader>h",
                builtin.help_tags,
                { noremap = true, desc = "Search help tags" }
            )
            vim.keymap.set("n", "<Leader>rc", function()
                builtin.find_files({
                    prompt_title = "Dotfiles",
                    cwd = "$HOME/personal/dotfiles",
                })
            end, { noremap = true, desc = "Find dotfiles" })
            vim.keymap.set(
                "n",
                "<Leader>m",
                builtin.diagnostics,
                { noremap = true, desc = "List all workspace diagnostics" }
            )

            vim.api.nvim_create_user_command(
                "Command",
                builtin.commands,
                { nargs = 0, desc = "List commands" }
            )
            vim.api.nvim_create_user_command(
                "Keymap",
                builtin.keymaps,
                { nargs = 0, desc = "List keymaps" }
            )

            -- NOTE: override keymaps defined in `lspconfig` module.
            vim.api.nvim_create_autocmd("LspAttach", {
                group = create_augroup("lsp-attach", { clear = false }),
                callback = function(event)
                    vim.keymap.set(
                        "n",
                        "gr",
                        builtin.lsp_references,
                        { buffer = event.buf, desc = "List references" }
                    )
                    vim.keymap.set(
                        "n",
                        "gi",
                        builtin.lsp_implementations,
                        { buffer = event.buf, desc = "Go to implementation" }
                    )
                    vim.keymap.set(
                        "n",
                        "gd",
                        builtin.lsp_definitions,
                        { buffer = event.buf, desc = "Go to definition" }
                    )
                    vim.keymap.set(
                        "n",
                        "<Leader>o",
                        builtin.lsp_document_symbols,
                        { buffer = event.buf, desc = "List document symbols" }
                    )
                    vim.keymap.set(
                        "n",
                        "gy",
                        builtin.lsp_type_definitions,
                        { buffer = event.buf, desc = "Go to type definition" }
                    )
                end,
            })
        end,
    },
}
