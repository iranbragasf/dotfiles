local M = {}

M.config = function()
    -- Add `:PackerLog` command to open `packer.nvim.log` in new tab
    vim.cmd([[command! -nargs=0 PackerLog execute 'lua vim.cmd("tabnew " .. vim.fn.stdpath("cache") .. "/packer.nvim.log")']])

    -- Add `:PackerDeleteCompiled` command to delete `packer_compiled.lua`
    vim.cmd([[command! -nargs=0 PackerDeleteCompiled execute 'lua vim.fn.delete(require("packer").config.compile_path)']])

    -- Automatically run `:PackerCompile` whenever plugins/init.lua is updated
    vim.cmd([[
        augroup packer_user_config
            autocmd!
            autocmd BufWritePost */plugins/init.lua source <afile> | PackerCompile
        augroup end
    ]])
end

local function is_packer_installed(install_path)
    if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
        return false
    end

    return true
end

M.download_packer = function()
    local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

    if is_packer_installed(install_path) then
        return
    end

    local answer = vim.fn.input(':: Download packer.nvim? [Y/n] ')
    vim.notify('\n')

    -- TODO: match answer with regex
    if answer == 'y' or answer == 'yes' or answer == 'Y' or answer == 'YES' or answer == '' then
        vim.notify(':: Downloading packer.nvim...', vim.log.levels.INFO)

        -- Remove the directory before cloning
        vim.fn.delete(install_path, 'rf')

        local packer_bootstrap = vim.fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })

        vim.notify(packer_bootstrap)

        -- Add packer to the current neovim session so no restarting is needed
        vim.cmd([[packadd packer.nvim]])

        local ok, _ = pcall(require, 'packer')

        if not ok then
            vim.notify("[ERROR] packer.nvim not downloaded", vim.log.levels.ERROR)
            return
        end

        vim.notify(':: packer.nvim successfully downloaded', vim.log.levels.INFO)

        return packer_bootstrap
    end
end

return M
