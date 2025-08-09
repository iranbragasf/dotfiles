local lhs = "<C-l>"
local desc = "Format document"

return {
    "stevearc/conform.nvim",
    enabled = not vim.g.enable_builtin_formatting,
    event = "BufWritePre",
    cmd = { "ConformInfo", "Format" },
    keys = {
        {
            lhs,
            nil,
            mode = { "n", "v" },
            desc = desc,
        },
    },
    config = function()
        local conform = require("conform")

        conform.setup({
            formatters_by_ft = {
                lua = { "stylua" },
                html = { "prettierd" },
                css = { "prettierd" },
                javascript = { "prettierd" },
                typescript = { "prettierd" },
                json = { "prettierd" },
                jsonc = { "prettierd" },
                yaml = { "prettierd" },
            },
            default_format_opts = {
                timeout_ms = 1000,
                lsp_format = "fallback",
            },
            format_on_save = function()
                return vim.g.format_on_save and {} or nil
            end,
        })

        vim.keymap.set({ "n", "v" }, lhs, function()
            conform.format(nil, function(err)
                if not err then
                    local mode = vim.api.nvim_get_mode().mode
                    if vim.startswith(string.lower(mode), "v") then
                        vim.api.nvim_feedkeys(
                            vim.api.nvim_replace_termcodes(
                                "<Esc>",
                                true,
                                false,
                                true
                            ),
                            "n",
                            true
                        )
                    end
                end
            end)
        end, { noremap = true, desc = desc })

        vim.api.nvim_create_user_command("Format", function(args)
            local range = nil
            if args.count ~= -1 then
                local end_line = vim.api.nvim_buf_get_lines(
                    0,
                    args.line2 - 1,
                    args.line2,
                    true
                )[1]
                range = {
                    start = { args.line1, 0 },
                    ["end"] = { args.line2, end_line:len() },
                }
            end
            conform.format({ range = range })
        end, { nargs = 0, range = true, desc = desc })
    end,
}
