return {
    -- TODO: set up LuaSnip keymaps.
    -- See: https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps and
    -- https://github.com/iranbragasf/dotfiles/blob/tilingwm/nvim/lua/iranbragasf/plugins/luasnip.lua
    'L3MON4D3/LuaSnip',
    version = '2.*',
    build = "make install_jsregexp",
    dependencies = {
        {
            'rafamadriz/friendly-snippets',
            config = function()
                require('luasnip.loaders.from_vscode').lazy_load()
            end,
        },
    },
}
