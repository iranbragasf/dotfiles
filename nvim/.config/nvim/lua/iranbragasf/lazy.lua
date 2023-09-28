local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

vim.api.nvim_create_autocmd("FileType", {
    group = "CursorLineInActiveWindow",
    pattern = 'lazy',
    callback = function()
        vim.api.nvim_win_set_option(0, "cursorline", true)
        vim.api.nvim_win_set_option(0, "signcolumn", "no")
        vim.keymap.set("n", "<Esc>", ":close<CR>", { noremap = true, silent = true, buffer = true })
    end,
})

require("lazy").setup({
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            {
                'folke/neodev.nvim',
                config = function()
                    require("neodev").setup()
                end
            },
            "b0o/schemastore.nvim",
        },
        config = function()
            require("iranbragasf.plugins.lspconfig")
        end
    },
    {
        "williamboman/mason.nvim",
        dependencies = { "williamboman/mason-lspconfig.nvim" },
        config = function()
            require("iranbragasf.plugins.mason")
        end
    },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-emoji',
            'onsails/lspkind-nvim',
        },
        config = function()
            require("iranbragasf.plugins.cmp")
        end
    },
    {
        "L3MON4D3/LuaSnip",
        version = "2.*",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
            require("iranbragasf.plugins.luasnip")
        end,
    },
    {
        "ray-x/lsp_signature.nvim",
        config = function()
            require("iranbragasf.plugins.lsp_signature")
        end
    },
    {
        "jose-elias-alvarez/null-ls.nvim",
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require("iranbragasf.plugins.null_ls")
        end
    },
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make'
            },
            'kyazdani42/nvim-web-devicons',
        },
        config = function()
            require("iranbragasf.plugins.telescope")
        end
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
        config = function()
            require("iranbragasf.plugins.treesitter")
        end,
    },
    {
        'numToStr/Comment.nvim',
        config = function()
            require("iranbragasf.plugins.comment")
        end
    },
    {
        'kyazdani42/nvim-tree.lua',
        cmd = "NvimTreeToggle",
        init = function()
            require("iranbragasf.plugins.nvim_tree").init()
        end,
        config = function()
            require("iranbragasf.plugins.nvim_tree").config()
        end,
    },
    {
        'mbbill/undotree',
        cmd = 'UndotreeToggle',
        init = function()
            vim.g.undotree_WindowLayout = 2
            vim.g.undotree_SplitWidth = 30
            vim.g.undotree_DiffAutoOpen = 0
            vim.g.undotree_SetFocusWhenToggle = 1
            vim.g.undotree_TreeVertShape = "│"
            vim.keymap.set("n", "<Leader>u", ":UndotreeToggle<CR>", {noremap = true, silent = true})
        end,
        config = function()
            require("iranbragasf.plugins.undotree")
        end
    },
    -- TODO: create an `EditorConfigGenerate` command to generate a
    -- `.editorconfig` file with base settings in project root
    "editorconfig/editorconfig-vim",
    'tpope/vim-sleuth',
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require("iranbragasf.plugins.gitsigns")
        end
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("iranbragasf.plugins.indent_blankline")
        end
    },
    {
        'iamcco/markdown-preview.nvim',
        build = 'cd app && npm install',
        ft = "markdown",
        init = function()
            vim.g.mkdp_auto_close = 0
        end
    },
    {
        "navarasu/onedark.nvim",
        priority = 1000,
        lazy = false,
        config = function()
            require("iranbragasf.plugins.onedark")
        end,
    },
}, { ui = { border = "rounded" } })
