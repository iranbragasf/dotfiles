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

    local mason_registry = require("mason-registry")

    mason.setup({
        ui = {
            border = "rounded",
        }
    })

    local ensure_installed = {
        "prettier",
        "eslint_d",
    }

    for _, package_name in ipairs(ensure_installed) do
        local package = mason_registry.get_package(package_name)

        if not package:is_installed() then
            local notify_opts = { title = "mason.nvim" }

            vim.notify(
                string.format("[mason.nvim] installing %s", package_name),
                vim.log.levels.INFO,
                notify_opts
            )

            package:install():once("closed", vim.schedule_wrap(function()
                if package:is_installed() then
                    vim.notify(
                        string.format(
                            "[mason.nvim] %s was successfully installed",
                            package_name
                        ),
                        vim.log.levels.INFO,
                        notify_opts
                    )
                else
                    vim.notify(
                        string.format(
                            "[mason.nvim] failed to install %s. Installation logs are available in :Mason and :MasonLog",
                            package_name
                        ),
                        vim.log.levels.ERROR,
                        notify_opts
                    )
                end
            end))
        end
    end

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
            local lspconfig = require("lspconfig")

            if server_opts[server_name] then
                lspconfig[server_name].setup(server_opts[server_name])
                return
            end

            lspconfig[server_name].setup(default_opts)
        end
    })
end

return M
