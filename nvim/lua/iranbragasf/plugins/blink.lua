return {
    "saghen/blink.cmp",
    enabled = not vim.g.enable_builtin_autocompletion,
    event = "VimEnter",
    version = "1.*",
    dependencies = {
        "L3MON4D3/LuaSnip",
        "disrupted/blink-cmp-conventional-commits",
        "bydlw98/blink-cmp-sshconfig",
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
        completion = {
            accept = {
                auto_brackets = {
                    enabled = false,
                },
            },
        },
        keymap = {
            ["<C-s>"] = { "show_signature", "hide_signature", "fallback" },
            ["<C-k>"] = false,
        },
        sources = {
            default = {
                "lsp",
                "path",
                "snippets",
                "buffer",
                "lazydev",
                "conventional_commits",
                "sshconfig",
            },
            providers = {
                lazydev = {
                    module = "lazydev.integrations.blink",
                    score_offset = 100,
                    enabled = function()
                        return vim.bo.filetype == "lua"
                    end,
                },
                conventional_commits = {
                    module = "blink-cmp-conventional-commits",
                    enabled = function()
                        return vim.bo.filetype == "gitcommit"
                    end,
                },
                sshconfig = {
                    module = "blink-cmp-sshconfig",
                    enabled = function()
                        return vim.bo.filetype == "sshconfig"
                    end,
                },
            },
        },
        signature = {
            enabled = true,
            window = {
                show_documentation = true,
            },
        },
        snippets = { preset = "luasnip" },
    },
}
