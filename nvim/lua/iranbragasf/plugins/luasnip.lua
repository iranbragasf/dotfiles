return {
    "L3MON4D3/LuaSnip",
    version = "2.*",
    build = "make install_jsregexp",
    dependencies = {
        {
            "rafamadriz/friendly-snippets",
            config = function()
                require("luasnip.loaders.from_vscode").lazy_load()
            end,
        },
    },
    config = function()
        local ls = require("luasnip")

        -- TODO: configure LuaSnip's advanced settings.
        -- TJ's series on LuaSnip:
        -- 1. https://youtu.be/Dn800rlPIho?si=nY_OVGgVsBvc1G5L
        -- 2. https://youtu.be/KtQZRAkgLqo?si=aV-hNFgNqORlLBID
        -- 3. https://youtu.be/aNWx-ym7jjI?si=BgAdcsse4qQVg2XQ
        ls.setup()

        vim.keymap.set("i", "<C-j>", function()
            return ls.expand_or_jumpable() and "<Plug>luasnip-expand-or-jump"
                or "<Tab>"
        end, {
            expr = true,
            silent = true,
            desc = "Expand or jump to the next placeholder in the current snippet",
        })
        vim.keymap.set("s", "<C-j>", function()
            ls.jump(1)
        end, {
            noremap = true,
            desc = "Jump to the next placeholder in the current snippet",
        })
        vim.keymap.set({ "i", "s" }, "<C-k>", function()
            ls.jump(-1)
        end, {
            noremap = true,
            desc = "Jump to the previous placeholder in the current snippet",
        })
    end,
}
