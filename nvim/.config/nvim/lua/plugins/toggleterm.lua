local M = {}

M.config = function()
    local function size(term)
        if term.direction == "horizontal" then
            return 12
        elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
        end
    end

    require("toggleterm").setup({
        size = size,
        open_mapping = "<F12>",
        shade_filetypes = { "none" }, -- Setting "none" will allow normal terminal buffers to be highlighted.
        direction = "horizontal", -- 'vertical' | 'horizontal' | 'window' | 'float'
        float_opts = { border = vim.g.border }
    })

    -- Mappings to make moving in and out of a terminal easier once toggled,
    -- whilst still keeping it open
    function _G.set_terminal_keymaps()
        local opts = { noremap = true }
        vim.api.nvim_buf_set_keymap(0, 't', '<Esc>', [[<C-\><C-n>]], opts)
        vim.api.nvim_buf_set_keymap(0, 't', '<C-w>h', [[<C-\><C-n><C-W>h]], opts)
        vim.api.nvim_buf_set_keymap(0, 't', '<C-w>j', [[<C-\><C-n><C-W>j]], opts)
        vim.api.nvim_buf_set_keymap(0, 't', '<C-w>k', [[<C-\><C-n><C-W>k]], opts)
        vim.api.nvim_buf_set_keymap(0, 't', '<C-w>l', [[<C-\><C-n><C-W>l]], opts)
    end

    -- To only apply these mappings for toggleterm "term://*toggleterm#*"
    -- should be used instead
    vim.cmd([[autocmd! TermOpen term://* lua set_terminal_keymaps()]])

    local Terminal  = require("toggleterm.terminal").Terminal

    local function float_handler(term)
        if vim.fn.mapcheck('<Esc>', 't') ~= '' then
            vim.api.nvim_buf_del_keymap(term.bufnr, 't', '<Esc>')
        end
    end

    local function get_float_opts(opts)
        local default_opts = {
            direction = "float",
            float_opts = {
                width = 130,
                height = 30
            },
            hidden = true,
            on_open = float_handler
        }

        return vim.tbl_extend("force" , default_opts, opts)
    end

    local lazygit = Terminal:new(get_float_opts({
        cmd = "lazygit",
        dir = "git_dir"
    }))
    function lazygit_toggle()
        lazygit:toggle()
    end

    local lazydocker = Terminal:new(get_float_opts({ cmd = "lazydocker" }))
    function lazydocker_toggle()
        lazydocker:toggle()
    end

    local htop = Terminal:new(get_float_opts({ cmd = "htop" }))
    function htop_toggle()
        htop:toggle()
    end

    vim.cmd([[command! -nargs=0 Lazygit execute 'lua lazygit_toggle()']])
    vim.cmd([[command! -nargs=0 Lazydocker execute 'lua lazydocker_toggle()']])
    vim.cmd([[command! -nargs=0 Htop execute 'lua htop_toggle()']])

    vim.api.nvim_set_keymap("n", "<Leader>lg", "<Cmd>Lazygit<CR>", {noremap = true})
    vim.api.nvim_set_keymap("n", "<Leader>ld", "<Cmd>Lazydocker<CR>", {noremap = true})

    vim.cmd([[autocmd FileType toggleterm setlocal signcolumn=no]])
end

return M
