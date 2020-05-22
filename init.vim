call plug#begin('~/.vim/plugged')
Plug 'ycm-core/YouCompleteMe'
Plug 'arakashic/chromatica.nvim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'wellle/context.vim'
Plug 'junegunn/fzf.vim'
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'huawenyu/neogdb.vim'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

Plug 'wadackel/vim-dogrun'

Plug 'morhetz/gruvbox'
Plug 'mhartington/oceanic-next'

Plug 'Yggdroot/indentLine'

"colorscheme
Plug 'chuling/vim-equinusocio-material'


call plug#end()

"set tabstop=4
"set shiftwidth=4
"set expandtab


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


" chromatica

let g:chromatica#enable_at_startup = 1
let g:chromatica#libclang_path = '/usr/lib/llvm-9/lib/libclang.so'
let g:chromatica#global_args = ['-isystem/usr/lib/llvm-9/lib/clang/9.0.0/include', '-isystem/usr/include/c++/9/']
let g:chromatica#highlight_feature_level = 5
let g:chromatica#search_source_args = 1

let g:ycm_confirm_extra_conf = 1


" if you prefer the default one, comment out this line
"let g:equinusocio_material_darker = 1

" make vertsplit invisible
"let g:equinusocio_material_hide_vertsplit = 1

"colorscheme equinusocio_material

" this theme has a buildin lightline theme, you can turn it on
"let g:lightline = {
"  \ 'colorscheme': 'equinusocio_material',
"\ }
