local cmp = require("cmp")

cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end
    },
    completion = {
        completeopt = "menuone,noinsert"
    },
    window = {
        completion = cmp.config.window.bordered({
            border = "none",
            side_padding = 0,
            col_offset = -3,
        }),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['C-y'] = cmp.mapping.confirm({ select = true }),
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    }),
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            local item = require("lspkind").cmp_format({
                mode = "symbol_text",
                maxwidth = 50,
                ellipsis_char = '...',
            })(entry, vim_item)
            local icon_and_kind = vim.split(item.kind, "%s", { trimempty = true })
            local icon = icon_and_kind[1]
            local kind = icon_and_kind[2]
            item.kind = " " .. (icon or "") .. " "
            item.menu = "    (" .. (kind or "") .. ")"
            return item
        end,
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'nvim_lua' },
        { name = 'path' },
        { name = 'emoji' },
    }, {
        { name = 'buffer' },
    })
})
