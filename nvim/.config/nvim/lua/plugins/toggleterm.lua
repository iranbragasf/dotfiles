local M = {}

M.config = function()
    local function size(term)
        if term.direction == "horizontal" then
            return 12
        elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
        end
    end

    local function float_handler(term)
        if vim.fn.mapcheck('<Esc>', 't') ~= '' then
            vim.api.nvim_buf_del_keymap(term.bufnr, 't', '<Esc>')
        end
    end

    require("toggleterm").setup({
        size = size,
        open_mapping = "<F12>",
        shade_filetypes = { "none" }, -- Setting "none" will allow normal terminal buffers to be highlighted.
        float_opts = {
            border = vim.g.border,
            height = 30
        }
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

    -- Custom terminals
    local Terminal  = require("toggleterm.terminal").Terminal

    local lazygit = Terminal:new({
        cmd = "lazygit",
        direction = "float",
        dir = "git_dir",
        hidden = true,
        on_open = float_handler
    })
    function lazygit_toggle()
        lazygit:toggle()
    end

    local lazydocker = Terminal:new({
        cmd = "lazydocker",
        direction = "float",
        hidden = true,
        on_open = float_handler
    })
    function lazydocker_toggle()
        lazydocker:toggle()
    end

    local htop = Terminal:new({
        cmd = "htop",
        direction = "float",
        hidden = true,
        on_open = float_handler
    })
    function htop_toggle()
        htop:toggle()
    end

    vim.cmd([[command! -nargs=0 Lazygit execute 'lua lazygit_toggle()']])
    vim.cmd([[command! -nargs=0 Lazydocker execute 'lua lazydocker_toggle()']])
    vim.cmd([[command! -nargs=0 Htop execute 'lua htop_toggle()']])

    vim.api.nvim_set_keymap("n", "<Leader>lg", "<Cmd>Lazygit<CR>", {noremap = true})
    vim.api.nvim_set_keymap("n", "<Leader>ld", "<Cmd>Lazydocker<CR>", {noremap = true})
end

return M
