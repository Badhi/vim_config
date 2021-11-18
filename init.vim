call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf.vim'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

Plug 'morhetz/gruvbox'
Plug 'mhartington/oceanic-next'

Plug 'Yggdroot/indentLine'

"colorscheme
Plug 'chuling/vim-equinusocio-material'

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp-status.nvim'

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'

Plug 'SirVer/ultisnips'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'hoob3rt/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'ryanoasis/vim-devicons'

Plug 'folke/trouble.nvim'

call plug#end()


if (has("termguicolors"))
    set termguicolors
endif

" Theme
syntax enable
colorscheme OceanicNext

set cursorline 

hi CursorLine   cterm=NONE ctermbg=238 ctermfg=None guibg=Grey11 guifg=None
autocmd InsertEnter <buffer> highlight  CursorLine ctermbg=238 ctermfg=None guibg=DarkGreen
autocmd InsertLeave <buffer> highlight  CursorLine ctermbg=white ctermfg=None guibg=Grey11

set tabstop=4 shiftwidth=4 expandtab
set number relativenumber

let g:indentLine_char_list = ['|']

set completeopt=menu,menuone,noselect

lua << EOF
local cmp = require'cmp'

cmp.setup({
snippet = {
  expand = function(args)
    vim.fn["UltiSnips#Anon"](args.body)
  end,
},
mapping = {
  ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
  ['<C-d>'] = cmp.mapping.scroll_docs(-4),
  ['<C-f>'] = cmp.mapping.scroll_docs(4),
  ['<C-Space>'] = cmp.mapping.complete(),
  ['<C-e>'] = cmp.mapping.close(),
  ['<CR>'] = cmp.mapping.confirm({ select = true }),
},
sources = {
  { name = 'nvim_lsp' },
  { name = 'ultisnips' },
  { name = 'buffer' },
}
})

local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

require'lspconfig'.clangd.setup{
    cmd = { 'clangd-12', '--background-index' , '--clang-tidy'},
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
}

require'lspconfig'.svlangserver.setup{
    cmd = {'svlangserver'},
    root = function() return '.' end,
}

require'lspconfig'.tsserver.setup{
    --cmd = {'/usr/local/bin/typescript-language-server', '--stdio'},
    on_attach = on_attach
}

local function lsp_status()
    if not pcall(require, 'lsp-status') then
        return 
    end
    return require'lsp-status'.status()
end

require'lualine'.setup {
  options = {
    icons_enabled = true,
    theme = 'gruvbox',
    --component_separators = {'', ''},
    --section_separators = {'', ''},
    disabled_filetypes = {}
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress', lsp_status},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.awk = {
  install_info = {
    url = "/mnt/e/Work/tree-sitter-awk", -- local path or git repo
    files = {"src/parser.c"}
  },
  filetype = "awk", -- if filetype does not agrees with parser name
--  used_by = {"bar", "baz"} -- additional filetypes that use this parser
  }

require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = { "javascript" }, -- List of parsers to ignore installing
  highlight = {
    enable = true,              -- false will disable the whole extension
    additional_vim_regex_highlighting = false,
  },
}

require "nvim-treesitter.configs".setup {
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  }
}

require'trouble'.setup{}


EOF

