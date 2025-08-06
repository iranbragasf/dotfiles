vim.api.nvim_create_user_command("GenerateEditorConfig", function()
    local config = [[
root = true

[*]
indent_style = space
indent_size = 4
end_of_line = lf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = false
]]

    local filepath = vim.fn.getcwd() .. "/.editorconfig"

    if vim.fn.filereadable(filepath) == 1 then
        vim.notify(
            "An .editorconfig file already exists at " .. filepath,
            vim.log.levels.ERROR
        )
        return
    end

    local file = io.open(filepath, "w")
    if not file then
        vim.notify(
            "Failed to generate an .editorconfig file",
            vim.log.levels.ERROR
        )
        return
    end

    file:write(config)
    file:close()
    vim.notify(
        ".editorconfig file generated at " .. filepath,
        vim.log.levels.INFO
    )
end, {
    nargs = 0,
    desc = "Generate an .editorconfig file",
})
