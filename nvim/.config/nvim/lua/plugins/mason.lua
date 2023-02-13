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

    local servers = {
        "lua_ls",
        "jsonls",
        "yamlls",
        "tsserver",
    }

    mason_lspconfig.setup({
        ensure_installed = servers,
    })

    local default_opts = require("plugins.lspconfig").default_opts
    local server_opts = require("plugins.lspconfig").server_opts
    mason_lspconfig.setup_handlers({
        function(server_name)
            local opts = default_opts

            if server_opts[server_name] then
                opts = vim.tbl_extend("force", opts, server_opts[server_name])
            end

            require('lspconfig')[server_name].setup(opts)
        end,
    })
end

return M
