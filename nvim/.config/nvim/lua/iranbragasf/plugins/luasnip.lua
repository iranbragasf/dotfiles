local luasnip = require("luasnip")
local types = require("luasnip.util.types")
require("luasnip.loaders.from_vscode").lazy_load()

luasnip.setup({
    history = true,
    update_events = "TextChanged,TextChangedI",
    delete_check_events = "TextChanged",
    enable_autosnippets = true,
    ext_opts = {
        [types.choiceNode] = {
            active = {
                virt_text = {{"●", "Constant"}}
            }
        },
    }
})

vim.keymap.set("i", "<C-k>", function()
    if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
    end
end)
vim.keymap.set("s", "<C-k>", function()
    luasnip.jump(1)
end)
vim.keymap.set({ "i", "s" }, "<C-j>", function()
    luasnip.jump(-1)
end)
vim.keymap.set({ "i", "s" }, "<C-e>", function()
    if luasnip.choice_active() then
        luasnip.change_choice(1)
    end
end)
