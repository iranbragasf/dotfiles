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

    vim.opt.shortmess:append("c") -- Don't pass messages to |ins-completion-menu|
    vim.opt.completeopt = { "menu", "menuone", "noselect" }

    local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    cmp.setup({
        mapping = {
            ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
            ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
            ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
            ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
            ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
            ['<C-e>'] = cmp.mapping({
                i = cmp.mapping.abort(),
                c = cmp.mapping.close()
            }),
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
                    luasnip.jump(-1)
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                else
                    fallback()
                end
            end, { "i", "s" })
        },
        -- REQUIRED - a snippet engine must be specified
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end
        },
        formatting = {
            fields = { "kind", "abbr", "menu" },
            format = lspkind.cmp_format({
                with_text = false,
                menu = ({
                    nvim_lsp = "[LSP]",
                    luasnip = "[LuaSnip]",
                    nvim_lua = "[Lua]",
                    emoji = "[Emoji]",
                    buffer = "[Buffer]",
                    path = "[Path]",
                    ["vim-dadbod-completion"] = "[DB]"
                })
            })
        },
        sources = {
            { name = 'nvim_lsp' },
            { name = "luasnip" },
            { name = 'nvim_lua' },
            { name = 'buffer' },
            { name = 'path' },
            { name = 'emoji' }
        }
    })

    local cmdline_format = function(_, vim_item)
        vim_item.kind = ""
        return vim_item
    end

    local cmdline_opts = {
        mapping = cmp.mapping.preset.cmdline(),
        formatting = { format = cmdline_format },
        sources = {
            { name = 'buffer' }
        }
    }

    -- Completions for `/` and `?` search based on current buffer
    cmp.setup.cmdline('/', cmdline_opts)
    cmp.setup.cmdline('?', cmdline_opts)

    vim.cmd([[
        augroup dadbod_completion
            autocmd!
            autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })
        augroup END
    ]])
end

return M
