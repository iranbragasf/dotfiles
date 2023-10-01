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
        completion = {
            col_offset = -3,
            side_padding = 0,
        }
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
            local kind = require("lspkind").cmp_format({
                mode = "symbol_text",
                preset = 'codicons',
                maxwidth = 50,
                ellipsis_char = '...',
            })(entry, vim_item)
            local icon_and_text = vim.split(kind.kind, "%s", { trimempty = true })
            local icon = icon_and_text[1]
            local text = icon_and_text[2]

            if vim.tbl_contains({ 'path' }, entry.source.name) then
                local devicon, hl_group = require('nvim-web-devicons').get_icon(entry:get_completion_item().label)
                if devicon then
                    icon = devicon
                    vim_item.kind_hl_group = hl_group
                end
            end

            kind.kind = " " .. (icon or "") .. " "
            kind.menu = "    (" .. (text or "") .. ")"

            return kind
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
