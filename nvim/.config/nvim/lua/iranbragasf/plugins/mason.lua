require("mason").setup({
    ui = {
        border = "rounded",
    }
})

local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
    ensure_installed = {
        "lua_ls",
        "tsserver",
        "eslint",
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
