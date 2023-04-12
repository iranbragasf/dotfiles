local M = {}

local install_missing_pkgs = function(pkg_list)
    local mason_registry = require("mason-registry")

    for _, pkg_name in ipairs(pkg_list) do
        local pkg = mason_registry.get_package(pkg_name)

        if not pkg:is_installed() then
            local notify_opts = { title = "mason.nvim" }

            vim.notify(
                string.format("[mason.nvim] installing %s", pkg_name),
                vim.log.levels.INFO,
                notify_opts
            )

            pkg:install():once("closed", vim.schedule_wrap(function()
                if pkg:is_installed() then
                    vim.notify(
                        string.format(
                            "[mason.nvim] %s was successfully installed",
                            pkg_name
                        ),
                        vim.log.levels.INFO,
                        notify_opts
                    )
                else
                    vim.notify(
                        string.format(
                            "[mason.nvim] failed to install %s. Installation logs are available in :Mason and :MasonLog",
                            pkg_name
                        ),
                        vim.log.levels.ERROR,
                        notify_opts
                    )
                end
            end))
        end
    end
end

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

    local ensure_installed = {
        "prettier",
        "eslint_d",
    }

    install_missing_pkgs(ensure_installed)

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
