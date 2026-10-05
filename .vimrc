color desert
syntax on

set colorcolumn=80
set signcolumn=yes
set termguicolors
set ignorecase

set autoindent
set smartindent
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround

set number
set relativenumber
set nowrap
set nocursorline
set scrolloff=8

set undodir="~/.vim/undodir"
set undofile
set noswapfile
set clipboard=unnamed

set foldenable
set foldlevel=99
set foldmethod=indent
set foldcolumn=0
set foldopen=
set foldlevelstart=99

set list
set listchars=tab:»\ ,trail:·,nbsp:␣

let g:netrw_liststyle = 1
let g:netrw_sort_by = 'size'

set background=dark
set laststatus=2

let g:mapleader = ' '

nnoremap <Leader>ex :Ex %:p:h<CR>
nnoremap <leader>w :update<CR>
nnoremap <leader>q :quit<CR>
nnoremap <leader>Q :wqa<CR>

nnoremap ; :
vnoremap ; :
xnoremap ; :

nnoremap : ;
vnoremap : ;
xnoremap : ;

" harpoon replacement
nnoremap <leader>a :argadd % <bar> argdedup<CR>
nnoremap <leader>l :args<CR>
nnoremap <C-h> :silent! 1argument<CR>
nnoremap <C-j> :silent! 2argument<CR>
nnoremap <C-k> :silent! 3argument<CR>
nnoremap <C-l> :silent! 4argument<CR>
