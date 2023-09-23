local M = {}

M.config = function()
    local mason_ok, mason = pcall(require, "mason")
    if not mason_ok then
        vim.notify("[ERROR] mason not loaded", vim.log.levels.ERROR)
        return
    end

    local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
    if not mason_lspconfig_ok then
        vim.notify("[ERROR] mason-lspconfig not loaded", vim.log.levels.ERROR)
        return
    end

    mason.setup({
        ui = {
            border = "rounded",
        }
    })

    mason_lspconfig.setup({
        ensure_installed = {
            "lua_ls",
            "jsonls",
            "yamlls",
            "tsserver",
        },
    })

    local default_server_opts = require("iranbragasf.plugins.lspconfig").default_server_opts
    local server_opts = require("iranbragasf.plugins.lspconfig").server_opts

    mason_lspconfig.setup_handlers({
        function(server_name)
            require("lspconfig")[server_name]
                .setup(server_opts[server_name] or default_server_opts)
        end
    })
end

return M
