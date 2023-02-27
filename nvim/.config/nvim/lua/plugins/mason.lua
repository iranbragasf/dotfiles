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

    local mason_null_ls_ok, mason_null_ls = pcall(require, "mason-null-ls")
    if not mason_null_ls_ok then
        vim.notify("[ERROR] mason-null-ls not loaded", vim.log.levels.ERROR)
        return
    end

    local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
    if not lspconfig_ok then
        vim.notify("[ERROR] lspconfig not loaded", vim.log.levels.ERROR)
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

    local default_opts = require("plugins.lspconfig").default_opts
    local server_opts = require("plugins.lspconfig").server_opts
    mason_lspconfig.setup_handlers({
        function(server_name)
            if server_opts[server_name] then
                lspconfig[server_name].setup(server_opts[server_name])
                return
            end

            lspconfig[server_name].setup(default_opts)
        end,
    })

    mason_null_ls.setup({
        automatic_installation = true,
    })
end

return M
