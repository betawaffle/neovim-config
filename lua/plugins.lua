local cmd = vim.cmd
local fn  = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local compile_path = fn.stdpath("config") .. "/lua/packer_compiled.lua"

local packer = nil
local packer_bootstrap = nil

local function packer_init()
    if packer == nil then
        packer = require("packer")
        packer.init {
            compile_path = compile_path,
        }
    end

    packer.reset()

    local use = packer.use

    use "wbthomason/packer.nvim"

    use "lewis6991/impatient.nvim"

    use "neovim/nvim-lspconfig"
    use "simrat39/rust-tools.nvim"

    use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }

    use "hrsh7th/nvim-cmp"
    use "hrsh7th/cmp-path"
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-calc"
    use "hrsh7th/cmp-emoji"
    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/cmp-nvim-lua"

    use "nvim-lua/popup.nvim"
    use "nvim-lua/plenary.nvim"

    use {
        "nvim-telescope/telescope.nvim",
        requires = {
            "nvim-lua/popup.nvim",
            "nvim-lua/plenary.nvim",
        },
    }

    use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }

    use {
        "nvim-lualine/lualine.nvim",
        requires = { "kyazdani42/nvim-web-devicons", opt = true },
    }

    use {
        "akinsho/bufferline.nvim",
        tag = 'v1.*',
        requires = "kyazdani42/nvim-web-devicons",
    }

    use "sainnhe/gruvbox-material"

    use {
        "kyazdani42/nvim-tree.lua",
        requires = "kyazdani42/nvim-web-devicons",
    }

    use "lnl7/vim-nix"

    use "folke/which-key.nvim"
    use "folke/twilight.nvim"

    use "ziglang/zig.vim"

    use "dingdean/wgsl.vim"

    -- nerdtree
    -- typescript-vim
    -- vim-airline
    -- vim-go
    -- vim-nix
    -- vim-terraform
    -- vim-toml
    -- vim-which-key
    -- zig-vim

    if packer_bootstrap then
        packer.sync()
    end
end

cmd [[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost plugins.lua source <afile> | PackerCompile
    augroup end
]]

cmd [[command! PackerInstall packadd packer.nvim | lua require('plugins').install()]]
cmd [[command! PackerUpdate  packadd packer.nvim | lua require('plugins').update()]]
cmd [[command! PackerSync    packadd packer.nvim | lua require('plugins').sync()]]
cmd [[command! PackerClean   packadd packer.nvim | lua require('plugins').clean()]]
cmd [[command! PackerCompile packadd packer.nvim | lua require('plugins').compile()]]

if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system {
        "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path
    }
end

return setmetatable({}, {
    __index = function(_, key)
        packer_init()
        return packer[key]
    end,
})
