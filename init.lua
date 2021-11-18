local opt = vim.opt
local cmd = vim.cmd

require 'paq' {
    'junegunn/fzf.vim',

    -- 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

    'morhetz/gruvbox',
    'mhartington/oceanic-next',

    'Yggdroot/indentLine',

    'chuling/vim-equinusocio-material',

    'neovim/nvim-lspconfig',
    'nvim-lua/lsp-status.nvim',

    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/nvim-cmp',

    'nvim-treesitter/nvim-treesitter',
    'nvim-treesitter/playground',

    'SirVer/ultisnips',
    'quangnguyen30192/cmp-nvim-ultisnips',

    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',

    'hoob3rt/lualine.nvim',
    'kyazdani42/nvim-web-devicons',
    'ryanoasis/vim-devicons',

    'folke/trouble.nvim',

}

opt.termguicolors = true
opt.cursorline = true
opt.tabstop=4
opt.shiftwidth=4
opt.expandtab= true
opt.number=true
opt.relativenumber=true


cmd('syntax enable')
cmd('colorscheme OceanicNext')
cmd('command CDC cd %:p:h')

require'treesitter'.setup()
require'lsp'.setup()
require'lualine-local'.setup()
require'cmp-local'.setup()

