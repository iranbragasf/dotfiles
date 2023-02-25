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

    local mason_update_all_ok, mason_update_all = pcall(require, "mason-update-all")
    if not mason_update_all_ok then
        vim.notify("[ERROR] mason-update-all not loaded", vim.log.levels.ERROR)
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
            local opts = default_opts

            if server_opts[server_name] then
                opts = vim.tbl_extend("force", opts, server_opts[server_name])
            end

            require('lspconfig')[server_name].setup(opts)
        end,
    })

    mason_null_ls.setup({
        automatic_installation = true,
    })

    mason_update_all.setup()
end

return M
