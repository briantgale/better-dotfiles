let mapleader="\<Space>"

call plug#begin('~/.vim/plugged')
  Plug 'scrooloose/nerdtree'
  Plug 'vim-ruby/vim-ruby'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
  Plug 'junegunn/fzf.vim'
  Plug 'jeetsukumaran/vim-buffergator'
  Plug 'tpope/vim-fugitive'
  Plug 'cocopon/iceberg.vim'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'mxw/vim-jsx'
  Plug 'isruslan/vim-es6'
  Plug 'pangloss/vim-javascript'
call plug#end()

" VimRC reloading/sourcing etc
nmap <leader>vm :e $MYVIMRC<CR>
nmap <leader>sv :source $MYVIMRC<CR>

" UI, Tabs, and Spaces
filetype plugin indent on
colorscheme iceberg
syntax on
set tabstop=2
set softtabstop=2
set expandtab
set showcmd
set cursorline
set title
set number
set numberwidth=6
nmap <leader>n :set invnumber<CR>
set cursorcolumn
set cursorline
set autoindent
set smartindent
set smarttab
nnoremap <down> :m .+1<CR>==
nnoremap <up> :m .-2<CR>==
vnoremap <down> :m '>+1<CR>gv=gv
vnoremap <up> :m '<-2<CR>gv=gv
autocmd FileType * setlocal ts=2 sts=2 sw=2

" Undo
set undodir=~/.vim/undodir
set undofile

" Buffergator
let g:buffergator_suppress_keymaps = 1
nmap <leader>m :BuffergatorToggle<CR>

" Split
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>
nnoremap <silent> <Leader>v :split<CR>
nnoremap <silent> <Leader>b :vsplit<CR>
nnoremap <silent> <Leader>q :close<CR>

" NerdTree
map <C-n> :NERDTreeToggle<CR>

" FZF
nnoremap <silent> <C-p> :FZF<CR>
" nnoremap <silent> <C-p> :GFiles<CR>

" Airline
let g:airline_theme='bubblegum'

" TMUX
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif
