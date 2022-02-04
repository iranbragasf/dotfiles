local M = {}

M.config = function()
    local ok, lsp_installer = pcall(require, "nvim-lsp-installer")
    if not ok then
        vim.notify("[ERROR] nvim-lsp-installer not loaded", vim.log.levels.ERROR)
        return
    end

    local servers = {
        "sumneko_lua",
        "jsonls",
        "yamlls",
        "tsserver",
        "prismals"
    }

    -- Automatically install Language Servers
    for _, name in pairs(servers) do
        local is_server_ok, server = lsp_installer.get_server(name)

        if is_server_ok then
            if not server:is_installed() then
                print("Installing " .. name)
                server:install()
            end
        end
    end

    -- Register a handler that will be called for all installed servers.
    -- Alternatively, handlers on specific servers can be registered instead
    lsp_installer.on_server_ready(function(server)
        local lspconfig_config = require("plugins.lspconfig")
        local default_opts = lspconfig_config.default_opts
        local server_opts = lspconfig_config.server_opts

        local opts = {
            on_attach = default_opts.on_attach,
            capabilities = default_opts.capabilities,
            flags = default_opts.flags
        }

        if server_opts[server.name] then
            server_opts[server.name](opts)
        end

        -- This setup() function is exactly the same as lspconfig's setup function.
        -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
        server:setup(opts)
    end)
end

return M
