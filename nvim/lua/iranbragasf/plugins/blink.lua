return {
    "saghen/blink.cmp",
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
        'disrupted/blink-cmp-conventional-commits',
        "bydlw98/blink-cmp-sshconfig",
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
        sources = {
            default = {
                "lsp",
                "path",
                "snippets",
                "buffer",
                "lazydev",
                "conventional_commits",
                "sshconfig"
            },
            providers = {
                lazydev = {
                    module = "lazydev.integrations.blink",
                    score_offset = 100,
                    enabled = function()
                        return vim.opt_local.filetype:get() == 'lua'
                    end,
                },
                conventional_commits = {
                    module = 'blink-cmp-conventional-commits',
                    enabled = function()
                        return vim.opt_local.filetype:get() == 'gitcommit'
                    end,
                },
                sshconfig = {
                    module = "blink-cmp-sshconfig",
                    enabled = function()
                        return vim.opt_local.filetype:get() == 'sshconfig'
                    end,
                }
            },
        },
        snippets = { preset = "luasnip" },
        signature = {
            enabled = true,
            window = {
                show_documentation = true
            }
        }
    },
}
