local M = {}

-- TODO: reload plugins without quiting
M.config = function()
    -- Add `:PackerLog` command to open `packer.nvim.log` in new tab
    vim.cmd([[command! -nargs=0 PackerLog execute 'lua vim.cmd("tabnew " .. vim.fn.stdpath("cache") .. "/packer.nvim.log")']])

    -- Add `:PackerDeleteCompiled` command to delete `packer_compiled.lua`
    vim.cmd([[command! -nargs=0 PackerDeleteCompiled execute 'lua vim.fn.delete(require("packer").config.compile_path)']])
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

    -- TODO: match answer with regex
    if answer == 'y' or answer == 'yes' or answer == 'Y' or answer == 'YES' or answer == '' then
        vim.notify(':: Downloading packer.nvim...')

        -- Remove the directory before cloning
        vim.fn.delete(install_path, 'rf')

        local packer_bootstrap = vim.fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })

        vim.notify(packer_bootstrap)

        local packer, _ = pcall(require, 'packer')

        if not packer then
            error('Error downloading packer.nvim!\npacker.nvim path: ' .. install_path)
            return
        end

        vim.notify(':: packer.nvim successfully downloaded')

        return packer_bootstrap
    end
end

return M
