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

lazy.setup({
    {
        "williamboman/mason.nvim",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "jay-babu/mason-null-ls.nvim",
            {
                'folke/neodev.nvim',
                config = function()
                    require("neodev").setup()
                end
            }
        },
        config = function()
            require("plugins.mason").config()
        end
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = { "b0o/schemastore.nvim" },
        init = function()
            require("plugins.lspconfig").init()
        end,
        config = function()
            require("plugins.lspconfig").config()
        end
    },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
            {
                'saadparwaiz1/cmp_luasnip',
                dependencies = { 'L3MON4D3/LuaSnip' }
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
    -- {
    --     "L3MON4D3/LuaSnip",
    --     dependencies = {
    --         "rafamadriz/friendly-snippets",
    --         config = function()
    --             require("luasnip.loaders.from_vscode").lazy_load()
    --         end,
    --     },
    --     opts = {
    --         history = true,
    --         delete_check_events = "TextChanged",
    --     },
    --     -- stylua: ignore
    --     keys = {
    --         {
    --             "<tab>",
    --             function()
    --                 return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
    --             end,
    --             expr = true, silent = true, mode = "i",
    --         },
    --         { "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
    --         { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
    --     },
    -- },
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
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
            'kyazdani42/nvim-web-devicons',
        },
        config = function ()
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
        dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
        config = function()
            require('plugins.comment').config()
        end
    },
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
    -- TODO: create a `EditorConfigGenerate` commannd to generate a
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
        "folke/tokyonight.nvim",
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("tokyonight")
        end,
    },
}, {
    ui = {
        border = "rounded"
    }
})

vim.api.nvim_create_autocmd("FileType", {
    group = "CursorLineInActiveWindow",
    pattern = 'lazy',
    callback = function()
        vim.api.nvim_win_set_option(0, "cursorline", true)
    end,
})
