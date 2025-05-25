require("ibl").setup({
    scope = { enabled = false },
    exclude = {
        filetypes = {
            "text",
            "conf",
            "markdown",
            "undotre",
        }
    }
})
