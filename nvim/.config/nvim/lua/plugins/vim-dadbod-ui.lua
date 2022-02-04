local M = {}

M.setup = function()
    vim.g.db_ui_execute_on_save = 0
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_winwidth = 30

    vim.api.nvim_set_keymap("n", "<Leader>db", ":DBUIToggle<CR>", {noremap = true, silent = true})
end

M.config = function()
    -- Default mappings
    vim.cmd([[autocmd FileType dbui  nmap <buffer> o         <Plug>(DBUI_SelectLine)]])
    vim.cmd([[autocmd FileType dbui  nmap <buffer> <CR>      <Plug>(DBUI_SelectLine)]])
    vim.cmd([[autocmd FileType dbui  nmap <buffer> S         <Plug>(DBUI_SelectLineVsplit)]])
    vim.cmd([[autocmd FileType dbui  nmap <buffer> A         <Plug>(DBUI_AddConnection)]])
    vim.cmd([[autocmd FileType dbui  nmap <buffer> K         <Plug>(DBUI_GotoPrevSibling)]])
    vim.cmd([[autocmd FileType dbui  nmap <buffer> J         <Plug>(DBUI_GotoNextSibling)]])
    vim.cmd([[autocmd FileType dbui  nmap <buffer> <C-k>     <Plug>(DBUI_GotoFirstSibling)]])
    vim.cmd([[autocmd FileType dbui  nmap <buffer> <C-j>     <Plug>(DBUI_GotoLastSibling)]])
    vim.cmd([[autocmd FileType dbui  nmap <buffer> <C-p>     <Plug>(DBUI_GotoParentNode)]])
    vim.cmd([[autocmd FileType sql   nmap <buffer> <Leader>W <Plug>(DBUI_SaveQuery)]])
    vim.cmd([[autocmd FileType sql   nmap <buffer> <Leader>S <Plug>(DBUI_ExecuteQuery)]])
    vim.cmd([[autocmd FileType sql   vmap <buffer> <Leader>S <Plug>(DBUI_ExecuteQuery)]])
    vim.cmd([[autocmd FileType dbout nmap <buffer> <Leader>R <Plug>(DBUI_ToggleResultLayout)]])

    -- Custom mappings which I don't want to override the default ones
    vim.cmd([[autocmd FileType dbui  nmap <buffer> l          <Plug>(DBUI_SelectLine)]])
    vim.cmd([[autocmd FileType dbui  nmap <buffer> h          <Plug>(DBUI_SelectLine)]])
    vim.cmd([[autocmd FileType dbui  nmap <buffer> <C-v>      <Plug>(DBUI_SelectLineVsplit)]])
    vim.cmd([[autocmd FileType dbui  nmap <buffer> a          <Plug>(DBUI_AddConnection)]])
    vim.cmd([[autocmd FileType dbui  nmap <buffer> <          <Plug>(DBUI_GotoPrevSibling)]])
    vim.cmd([[autocmd FileType dbui  nmap <buffer> >          <Plug>(DBUI_GotoNextSibling)]])
    vim.cmd([[autocmd FileType dbui  nmap <buffer> K          <Plug>(DBUI_GotoFirstSibling)]])
    vim.cmd([[autocmd FileType dbui  nmap <buffer> J          <Plug>(DBUI_GotoLastSibling)]])
    vim.cmd([[autocmd FileType dbui  nmap <buffer> P          <Plug>(DBUI_GotoParentNode)]])
    vim.cmd([[autocmd FileType sql   nmap <buffer> <C-s>      <Plug>(DBUI_SaveQuery)]])
    vim.cmd([[autocmd FileType sql   nmap <buffer> <Leader>r  <Plug>(DBUI_ExecuteQuery)]])
    vim.cmd([[autocmd FileType sql   vmap <buffer> <Leader>r  <Plug>(DBUI_ExecuteQuery)]])
    vim.cmd([[autocmd FileType dbout nmap <buffer> <Leader>dv <Plug>(DBUI_ToggleResultLayout)]])

    -- Exit if `vim-dadbod-ui` is the only window left
    vim.cmd([[autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && &filetype == 'dbui' | quit | endif]])

    vim.cmd([[autocmd FileType dbui  setlocal signcolumn=no]])
    vim.cmd([[autocmd FileType dbout setlocal signcolumn=no norelativenumber]])
end

return M
