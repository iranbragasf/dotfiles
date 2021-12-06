local packer_bootstrap = require("plugins.packer").download_packer()

return require('packer').startup({function(use)
    -- Packer can manage itself
    use {
        'wbthomason/packer.nvim',
        config = require('plugins.packer').config
    }

    use {
        'neovim/nvim-lspconfig',
        config = require('plugins.lspconfig').config
    }

    use {
        'williamboman/nvim-lsp-installer',
        config = require('plugins.nvim-lsp-installer').config
    }

    use {
        'hrsh7th/nvim-cmp',
        config = require('plugins.nvim-cmp').config,
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
                requires = { 'L3MON4D3/LuaSnip' }
            }
        }
    }

    use {
        "ray-x/lsp_signature.nvim",
        config = require('plugins.lsp_signature').config
    }

    use {
        'kyazdani42/nvim-tree.lua',
        cmd = 'NvimTreeToggle',
        setup = require('plugins.nvim-tree').setup,
        config = require('plugins.nvim-tree').config,
        requires = { 'kyazdani42/nvim-web-devicons' }
    }

    use { "editorconfig/editorconfig-vim" }

    use {
        'mbbill/undotree',
        cmd = 'UndotreeToggle',
        setup = require("plugins.undotree").setup,
        config = require("plugins.undotree").config
    }

    use {
        'nvim-telescope/telescope.nvim',
        config = require("plugins.telescope").config,
        requires = {
            'nvim-lua/plenary.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
            'kyazdani42/nvim-web-devicons'
        }
    }

    use {
        'monsonjeremy/onedark.nvim',
        config = function()
            require('onedark').setup({ functionStyle = "italic" })
            vim.cmd([[colorscheme onedark]])
        end
    }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Must be put at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
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
