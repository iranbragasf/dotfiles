local M = {}

M.config = function()
    vim.cmd([[autocmd! FileType lspinfo nnoremap <silent><buffer> q :q<CR>]])

    -- Add `:LspLog` command to open `lsp.log` file in new tab
    vim.cmd([[command! -nargs=0 LspLog execute 'lua vim.cmd("tabnew " .. vim.lsp.get_log_path())']])
end

return M
