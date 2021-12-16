local M = {}

M.search_dotfiles = function()
    require("telescope.builtin").find_files({
        prompt_title = "Dotfiles",
        cwd = "$HOME/dotfiles"
    })
end

M.config = function()
    local action_layout = require("telescope.actions.layout")

    require('telescope').setup {
        defaults = {
            sorting_strategy = "ascending",
            layout_config = {
                prompt_position = "top",
                horizontal = { preview_width = 0.5 }
            },
            prompt_prefix = "❯ ",
            selection_caret = "❯ ",
            vimgrep_arguments = {
                'rg',
                '--color=never',
                '--no-heading',
                '--with-filename',
                '--line-number',
                '--column',
                '--smart-case',
                '--hidden',
                '--follow',
                "--trim", -- Trim the indentation at the beginning of presented line in the result window
                "--glob=!{.git,node_modules,coverage,__pycache__}" -- Exclude files and directories
            },
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
                "%.git/",
                "node_modules/",
                "coverage/",
                "__pycache__/",
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
            }
        }
    }

    -- To get extensions loaded and working with telescope, `load_extension`
    -- must to be called somewhere after setup function
    require('telescope').load_extension('fzf')

    vim.api.nvim_set_keymap("n", "<C-p>", "<Cmd>lua require('telescope.builtin').find_files()<CR>", {noremap = true})
    vim.api.nvim_set_keymap("n", "<C-f>", "<Cmd>lua require('telescope.builtin').live_grep()<CR>", {noremap = true})
    vim.api.nvim_set_keymap("n", '<Leader>fb', "<Cmd>lua require('telescope.builtin').buffers()<CR>", {noremap = true})
    vim.api.nvim_set_keymap("n", "<Leader>fh", "<Cmd>lua require('telescope.builtin').help_tags()<CR>", {noremap = true})
    vim.api.nvim_set_keymap("n", "<Leader>fg", "<Cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.input('Find word: ') })<CR>", {noremap = true})
    -- Find word below the cursor accross project files
    vim.api.nvim_set_keymap("n", "<Leader>fw", "<Cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.expand('<cword>') })<CR>", {noremap = true})
    -- Find highlighted words accross project files
    vim.api.nvim_set_keymap("v", "<Leader>fw", [[y:lua require('telescope.builtin').grep_string({ search = vim.fn.expand('<C-r><C-r>"') })<CR>]], {noremap = true})
    vim.api.nvim_set_keymap("n", "<Leader>fc", "<Cmd>lua require('telescope.builtin').commands()<CR>", {noremap = true})
    vim.api.nvim_set_keymap("n", "<Leader>fk", "<Cmd>lua require('telescope.builtin').keymaps()<CR>", {noremap = true})
    vim.api.nvim_set_keymap("n", "q:", "<Cmd>lua require('telescope.builtin').command_history()<CR>", {noremap = true})
    vim.api.nvim_set_keymap("n", [[q/]], "<Cmd>lua require('telescope.builtin').search_history()<CR>", {noremap = true})
    vim.api.nvim_set_keymap("n", [[q?]], "<Cmd>lua require('telescope.builtin').search_history()<CR>", {noremap = true})
    vim.api.nvim_set_keymap("n", "<Leader>s", "<Cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>", {noremap = true})
    vim.api.nvim_set_keymap("n", "<Leader>S", "<Cmd>lua require('telescope.builtin').lsp_workspace_symbols()<CR>", {noremap = true})
    vim.api.nvim_set_keymap("n", "<Leader>ac", "<Cmd>lua require('telescope.builtin').lsp_code_actions()<CR>", {noremap = true})
    vim.api.nvim_set_keymap("n", "<Leader>g", "<Cmd>Telescope diagnostics bufnr=0 previewer=false<CR>", {noremap = true})
    vim.api.nvim_set_keymap("n", "<Leader>G", "<Cmd>Telescope diagnostics previewer=false<CR>", {noremap = true})
    vim.api.nvim_set_keymap("n", "<Leader>rc", "<Cmd>lua require('plugins.telescope').search_dotfiles()<CR>", {noremap = true})
end

return M
