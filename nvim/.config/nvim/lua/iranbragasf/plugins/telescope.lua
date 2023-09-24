local telescope = require("telescope")
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
    }
})

telescope.load_extension("fzf")

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
vim.keymap.set("n", "<Leader>g", function() builtin.diagnostics({ bufnr = 0, previewer = false }) end, {noremap = true})
vim.keymap.set("n", "<Leader>G", function() builtin.diagnostics({ previewer = false }) end, {noremap = true})
vim.keymap.set("n", "gd", builtin.lsp_definitions, {noremap = true})
vim.keymap.set("n", "gi", builtin.lsp_implementations, {noremap = true})
vim.keymap.set("n", "gy", builtin.lsp_type_definitions, {noremap = true})
vim.keymap.set("n", "gr", builtin.lsp_references, {noremap = true})
vim.keymap.set("n", "<Leader>rc", function()
    builtin.find_files({
        prompt_title = "Dotfiles",
        cwd = "$HOME/dotfiles"
    })
end, { noremap = true })

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
