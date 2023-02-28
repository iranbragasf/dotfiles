local M = {}

M.config = function()
    local telescope_ok, telescope = pcall(require, "telescope")
    if not telescope_ok then
        vim.notify("[ERROR] telescope not loaded", vim.log.levels.ERROR)
        return
    end

    local action_layout = require("telescope.actions.layout")
    local builtin = require('telescope.builtin')
    local telescope_config = require("telescope.config")

    local vimgrep_arguments = { unpack(telescope_config.values.vimgrep_arguments) }
    local extra_vimgrep_arguments = {
        "--hidden",
        "--follow",
        "--trim",
        "--glob",
        "!**/{.git,node_modules,coverage,__pycache__}/*",
    }
    for _, argument in ipairs(extra_vimgrep_arguments) do
        table.insert(vimgrep_arguments, argument)
    end

    telescope.setup({
        defaults = {
            sorting_strategy = "ascending",
            layout_config = {
                prompt_position = "top",
                horizontal = { preview_width = 0.5 }
            },
            prompt_prefix = "❯ ",
            selection_caret = "❯ ",
            vimgrep_arguments = vimgrep_arguments,
            mappings = {
                i = {
                    ["<Esc>"] = "close",
                    ["<C-j>"] = "move_selection_next",
                    ["<C-k>"] = "move_selection_previous",
                    ["<C-s>"] = "select_horizontal",
                    ["<C-a>"] = "toggle_all",
                    ["<M-p>"] = action_layout.toggle_preview
                }
            },
            file_ignore_patterns = {
                "^.git/",
                "^node_modules/",
                "^coverage/",
                "^__pycache__/",
                "%.o"
            }
        },
        pickers = {
            find_files = {
                hidden = true,
                follow = true
            },
            buffers = {
                mappings = {
                    i = {
                        ["<C-x>"] = "delete_buffer"
                    }
                }
            }
        },
        extensions = {
            fzf = {
                fuzzy = true,
                override_generic_sorter = true,
                override_file_sorter = true,
                case_mode = "smart_case"
            },
            undo = {
                layout_config = {
                    horizontal = { preview_width = 0.75 }
                },
                entry_format = "#$ID, $STAT, $TIME",
            },
        }
    })

    local extensions = {
        "fzf",
        "undo",
    }

    for _, extension in ipairs(extensions) do
        telescope.load_extension(extension)
    end

    vim.keymap.set("n", "<C-p>", builtin.find_files, {noremap = true})
    vim.keymap.set("n", "<C-f>", builtin.live_grep, {noremap = true})
    vim.keymap.set("n", '<Leader>fb', builtin.buffers, {noremap = true})
    vim.keymap.set("n", "<Leader>fh", builtin.help_tags, {noremap = true})
    vim.keymap.set("n", "<Leader>fg", function() builtin.grep_string({ search = vim.fn.input({ prompt = "Find word: " }) }) end, {noremap = true})
    vim.keymap.set("n", "<Leader>fw", function() builtin.grep_string({ search = vim.fn.expand('<cword>') }) end, {noremap = true})
    vim.keymap.set("v", "<Leader>fw", [[y:lua require('telescope.builtin').grep_string({ search = vim.fn.expand('<C-r><C-r>"') })<CR>]], {noremap = true})
    vim.keymap.set("n", "<Leader>fc", builtin.commands, {noremap = true})
    vim.keymap.set("n", "<Leader>fk", builtin.keymaps, {noremap = true})
    vim.keymap.set("n", "<Leader>s", builtin.lsp_document_symbols, {noremap = true})
    vim.keymap.set("n", "<Leader>S", builtin.lsp_workspace_symbols, {noremap = true})
    vim.keymap.set("n", "<Leader>g", ":Telescope diagnostics bufnr=0 previewer=false<CR>", {noremap = true, silent = true})
    vim.keymap.set("n", "<Leader>G", ":Telescope diagnostics previewer=false<CR>", {noremap = true, silent = true})
    vim.keymap.set("n", "<Leader>rc", function()
        builtin.find_files({
            prompt_title = "Dotfiles",
            cwd = "$HOME/dotfiles"
        })
    end, { noremap = true })
    vim.keymap.set("n", "<Leader>u", telescope.extensions.undo.undo, {noremap = true, silent = true})

    vim.api.nvim_create_autocmd("User", {
        pattern = "TelescopePreviewerLoaded",
        callback = function()
            vim.api.nvim_win_set_option(0, "wrap", true)
        end,
    })

    vim.api.nvim_create_autocmd("FileType", {
        pattern = "TelescopePrompt",
        callback = function()
            vim.api.nvim_win_set_option(0, "cursorline", false)
        end,
    })
end

return M
