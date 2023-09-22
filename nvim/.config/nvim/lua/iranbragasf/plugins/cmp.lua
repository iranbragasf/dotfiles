local M = {}

M.config = function()
    local cmp_ok, cmp = pcall(require, "cmp")
    if not cmp_ok then
        vim.notify("[ERROR] cmp not loaded", vim.log.levels.ERROR)
        return
    end

    local luasnip_ok, luasnip = pcall(require, "luasnip")
    if not luasnip_ok then
        vim.notify("[ERROR] luasnip not loaded", vim.log.levels.ERROR)
        return
    end

    local lspkind_ok, lspkind = pcall(require, "lspkind")
    if not lspkind_ok then
        vim.notify("[ERROR] lspkind not loaded", vim.log.levels.ERROR)
        return
    end

    cmp.setup({
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end
        },
        completion = {
            completeopt = "menu,menuone,noinsert"
        },
        window = {
            completion = {
                col_offset = -3,
                side_padding = 0,
            },
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
                local kind = lspkind.cmp_format({
                    mode = "symbol_text",
                    maxwidth = 50,
                })(entry, vim_item)
                local strings = vim.split(kind.kind, "%s", { trimempty = true })
                kind.kind = " " .. (strings[1] or "") .. " "
                kind.menu = "    (" .. (strings[2] or "") .. ")"
                return kind
            end,
        },
        sources = cmp.config.sources({
            {
                name = 'nvim_lsp',
                entry_filter = function(entry, ctx)
                    if entry:get_kind() == 15 then
                        return false
                    end
                    return true
                end
            },
            { name = 'luasnip' },
            { name = 'nvim_lua' },
            { name = 'path' },
            { name = 'emoji' },
        }, {
            { name = 'buffer' },
        })
    })
end

local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not cmp_nvim_lsp_ok then
    vim.notify("[ERROR] cmp_nvim_lsp not loaded", vim.log.levels.ERROR)
    return
end
M.capabilities = cmp_nvim_lsp.default_capabilities()

return M
