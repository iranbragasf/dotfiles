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

local lazy_ok, lazy = pcall(require, "lazy")
if not lazy_ok then
    vim.notify("[ERROR] lazy.nvim not loaded", vim.log.levels.ERROR)
    return
end

vim.api.nvim_create_autocmd("FileType", {
    group = "CursorLineInActiveWindow",
    pattern = 'lazy',
    callback = function()
        vim.api.nvim_win_set_option(0, "cursorline", true)
        vim.api.nvim_win_set_option(0, "signcolumn", "no")
        vim.keymap.set("n", "<Esc>", ":close<CR>", { noremap = true, silent = true, buffer = true })
    end,
})

lazy.setup({
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
            require("plugins.lspconfig").config()
        end
    },
    {
        "williamboman/mason.nvim",
        dependencies = { "williamboman/mason-lspconfig.nvim" },
        config = function()
            require("plugins.mason").config()
        end
    },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
            {
                'saadparwaiz1/cmp_luasnip',
                dependencies = { "L3MON4D3/LuaSnip" },
            },
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-emoji',
            'onsails/lspkind-nvim',
        },
        config = function()
            require("plugins.cmp").config()
        end
    },
    {
        "L3MON4D3/LuaSnip",
        version = "1.*",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
            require("plugins.luasnip").config()
        end,
    },
    {
        "ray-x/lsp_signature.nvim",
        config = function()
            require('plugins.lsp_signature').config()
        end
    },
    {
        "jose-elias-alvarez/null-ls.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("plugins.null_ls").config()
        end
    },
    {
        'nvim-telescope/telescope.nvim',
        version = '*',
        dependencies = {
            'nvim-lua/plenary.nvim',
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make'
            },
            'kyazdani42/nvim-web-devicons',
        },
        config = function()
            require("plugins.telescope").config()
        end
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
        config = function()
            require("plugins.treesitter").config()
        end,
    },
    {
        'numToStr/Comment.nvim',
        config = function()
            require('plugins.comment').config()
        end
    },
    -- TODO: preview images in buffers
    {
        'kyazdani42/nvim-tree.lua',
        dependencies = { 'kyazdani42/nvim-web-devicons' },
        cmd = "NvimTreeToggle",
        init = function()
            require('plugins.nvim_tree').init()
        end,
        config = function()
            require('plugins.nvim_tree').config()
        end,
    },
    {
        'mbbill/undotree',
        cmd = 'UndotreeToggle',
        init = function()
            require("plugins.undotree").init()
        end,
        config = function()
            require("plugins.undotree").config()
        end
    },
    -- TODO: create an `EditorConfigGenerate` command to generate a
    -- `.editorconfig` file with base settings in project root
    { "editorconfig/editorconfig-vim" },
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require("plugins.gitsigns").config()
        end
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("plugins.indent_blankline").config()
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
        config = function()
            require('onedark').setup {
                style = 'darker',
                comments = 'italic',
                keywords = 'italic',
            }
            require('onedark').load()
        end,
    },
}, { ui = { border = "rounded" } })
