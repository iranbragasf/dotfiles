local packer_bootstrap = require("plugins.packer").download_packer()

local ok, packer = pcall(require, "packer")

if not ok then
    return
end

local function exec_setup(plugin_name)
    require("plugins." .. plugin_name).setup()
end

local function exec_config(plugin_name)
    require("plugins." .. plugin_name).config()
end

return packer.startup({function(use)
    -- Packer can manage itself
    use {
        'wbthomason/packer.nvim',
        config = exec_config("packer")
    }

    use {
        'neovim/nvim-lspconfig',
        config = exec_config('lspconfig'),
        requires = { "b0o/schemastore.nvim" }
    }

    use {
        'williamboman/nvim-lsp-installer',
        config = exec_config('nvim-lsp-installer')
    }

    use({
        "jose-elias-alvarez/null-ls.nvim",
        config = exec_config('null-ls'),
        requires = { "nvim-lua/plenary.nvim" }
    })

    use {
        'hrsh7th/nvim-cmp',
        config = exec_config('nvim-cmp'),
        requires = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-emoji',
            'onsails/lspkind-nvim',
            {
                'kristijanhusak/vim-dadbod-completion',
                requires = { 'tpope/vim-dadbod' }
            },
            {
                'saadparwaiz1/cmp_luasnip',
                -- TODO: configure snipets
                requires = { 'L3MON4D3/LuaSnip' }
            }
        }
    }

    use {
        "ray-x/lsp_signature.nvim",
        config = exec_config('lsp_signature')
    }

    use {
        'numToStr/Comment.nvim',
        config = exec_config('Comment')
    }

    use {
        'kristijanhusak/vim-dadbod-ui',
        cmd = { "DBUIToggle", "DBUIAddConnection" },
        setup = exec_setup('vim-dadbod-ui'),
        requires = { 'tpope/vim-dadbod' }
    }

    use {
        'kyazdani42/nvim-tree.lua',
        setup = exec_setup('nvim-tree'),
        config = exec_config('nvim-tree'),
        requires = { 'kyazdani42/nvim-web-devicons' }
    }

    -- TODO: create a `EditorConfigGenerate` commannd to generate a
    -- `.editorconfig` file with base settings in project root
    use { "editorconfig/editorconfig-vim" }

    use {
        'mbbill/undotree',
        cmd = 'UndotreeToggle',
        setup = exec_setup("undotree"),
        config = exec_config("undotree")
    }

    use {
        'nvim-telescope/telescope.nvim',
        config = exec_config("telescope"),
        requires = {
            'nvim-lua/plenary.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
            'kyazdani42/nvim-web-devicons'
        }
    }

    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = exec_config("treesitter"),
        requires = {
            'nvim-treesitter/playground',
            'JoosepAlviste/nvim-ts-context-commentstring'
        }
    }

    use {
        'lewis6991/gitsigns.nvim',
        config = exec_config("gitsigns"),
        requires = { 'nvim-lua/plenary.nvim' }
    }

    use {
        "akinsho/nvim-toggleterm.lua",
        config = exec_config("toggleterm")
    }

    use {
        "lukas-reineke/indent-blankline.nvim",
        config = exec_config("indent-blankline")
    }

    use {
        'monsonjeremy/onedark.nvim',
        config = exec_config('onedark')
    }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Must be put at the end after all plugins
    if packer_bootstrap then
        packer.sync()
    end
end,
config = {
    display = {
        open_fn = function()
            return require('packer.util').float({ border = vim.g.border })
        end,
        prompt_border = vim.g.border
    }
}})
