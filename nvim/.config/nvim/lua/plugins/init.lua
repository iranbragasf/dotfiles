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
        'kyazdani42/nvim-tree.lua',
        cmd = 'NvimTreeToggle',
        setup = require('plugins.nvim-tree').setup,
        config = require('plugins.nvim-tree').config,
        requires = { 'kyazdani42/nvim-web-devicons' }
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
