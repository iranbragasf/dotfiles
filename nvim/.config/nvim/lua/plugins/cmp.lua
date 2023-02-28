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

    local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    vim.opt.completeopt = { "menu", "menuone", "noselect" }
    vim.opt.shortmess:append("c")

    cmp.setup({
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end
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
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s" }),
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
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'nvim_lua' },
            { name = 'path' },
            { name = 'emoji' },
        }, {
            { name = 'buffer' }
        })
    })

    cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        window = {
            completion = {
                col_offset = -3,
                side_padding = 0,
            },
        },
        formatting = {
            format = function(_, vim_item)
                vim_item.kind = ""
                return vim_item
            end,
        },
        sources = {
            { name = 'buffer' },
        }
    })
end

local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not cmp_nvim_lsp_ok then
    vim.notify("[ERROR] cmp_nvim_lsp not loaded", vim.log.levels.ERROR)
    return
end
M.capabilities = cmp_nvim_lsp.default_capabilities()

return M
