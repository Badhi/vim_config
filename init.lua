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
    'nvim-treesitter/nvim-treesitter-textobjects',

    'SirVer/ultisnips',
    'quangnguyen30192/cmp-nvim-ultisnips',

    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',

    'hoob3rt/lualine.nvim',
    'kyazdani42/nvim-web-devicons',
    'ryanoasis/vim-devicons',

    'folke/trouble.nvim',

    'tami5/lspsaga.nvim',
    'badhi/nvim-treesitter-cpp-tools',
    'Badhi/yabs.nvim',

    'mfussenegger/nvim-dap',
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
    'jbyuki/one-small-step-for-vimkind',
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

-- Telescope commands
local opts = { noremap = true, silent = true}
vim.api.nvim_set_keymap('n', '<leader>fo', "<cmd>:Telescope oldfiles<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>fb', "<cmd>:Telescope buffers<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>ff', "<cmd>:Telescope find_files<CR>", opts)

--window resizing
vim.api.nvim_set_keymap('n', '<Leader>+', ':exe "resize " . (winheight(0) * 3/2)<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>-', ':exe "resize " . (winheight(0) * 2/3)<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>]', ':exe "vertical resize " . (winwidth(0) * 3/2)<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>[', ':exe "vertical resize " . (winwidth(0) * 2/3)<CR>', opts)

vim.api.nvim_set_keymap('n', '<C-F2>', ':res +1<CR>', opts)
vim.api.nvim_set_keymap('n', '<C-F3>', ':res -1<CR>', opts)
vim.api.nvim_set_keymap('n', '<C-F4>', ':vertical resize +1<CR>', opts)
vim.api.nvim_set_keymap('n', '<C-F5>', ':vertical resize -1<CR>', opts)


require'treesitter'.setup()
require'lsp'.setup()
require'lualine-local'.setup()
require'cmp-local'.setup()
require'debug-adapters'.setup()
require'jobs'.setup()

