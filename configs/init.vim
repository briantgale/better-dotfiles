let mapleader="\,"

" Plugins
call plug#begin('~/.vim/plugged')
  " File searching
  Plug 'scrooloose/nerdtree'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
  Plug 'junegunn/fzf.vim'
  Plug 'jeetsukumaran/vim-buffergator'

  " Sytax
  Plug 'vim-ruby/vim-ruby'
  Plug 'mxw/vim-jsx'
  Plug 'isruslan/vim-es6'
  Plug 'pangloss/vim-javascript'
  Plug 'stephpy/vim-yaml'

  " Plug 'yggdroot/indentline'
  Plug 'rstacruz/vim-closer'
  Plug 'jiangmiao/auto-pairs'
  Plug 'scrooloose/nerdcommenter'
  " Plug 'myusuf3/numbers.vim'
  Plug 'alvan/vim-closetag'
	Plug 'tpope/vim-haml'

  " Git
  Plug 'tpope/vim-fugitive'
  Plug 'airblade/vim-gitgutter'
  Plug 'rhysd/git-messenger.vim'
  " Plug 'mhinz/vim-signify'

  " Views
  " Plug 'cocopon/iceberg.vim'
  " Plug 'joshdick/onedark.vim'
  Plug 'tomasr/molokai'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'slim-template/vim-slim'

  " Text completion & Syntax Checking
  " Plug 'w0rp/ale' " Linting
  Plug 'ervandew/supertab' " Tab completion
  Plug 'tpope/vim-endwise' " Ruby end tag completion

  " VIM
  Plug 'guns/xterm-color-table.vim'
  Plug 'mhinz/vim-startify'
  " Plug 'junegunn/goyo.vim'
  Plug 'djoshea/vim-autoread'
  Plug 'ap/vim-buftabline'
  " Plug 'metakirby5/codi.vim'
call plug#end()

"""""""""
"" VIM ""
"""""""""

" Load and source vimrc
nmap <leader>vv :e $MYVIMRC<CR>
nmap <leader>sv :source $MYVIMRC<CR>
nmap <leader>pp :PlugInstall<CR>

"" Color Scheme
" colorscheme iceberg
" colorscheme onedark
colorscheme molokai

" Enable syntax highlighting
syntax on
" set termguicolors

" Enable filetype detection pugin and indent
filetype plugin indent on

" Indentation
set tabstop=2
set softtabstop=2
set expandtab
set smarttab
set autoindent
set smartindent

" Shows the command
set showcmd

" Shows the page title
set title

" Display the number column by default
set number

" Toggle number column
nmap <leader>n :set invnumber<CR> 

" Automatcially reload a file that's been saved elsewhere
set autoread

" Supress message that a buffer hasn't been saved when changing
set hidden

" Searches
set ignorecase " searches are case insensitive...
set smartcase  " ... unless they contain at least one capital letter

" Buffers
nnoremap <silent>; :Buffers<CR>
nnoremap <Leader>l :bn<CR>
nnoremap <Leader>h :bn<CR>

" Use the system clipboard when using y and p
set clipboard+=unnamed

" Quickly insert an empty new line without entering insert mode
nnoremap <Leader>o o<Esc>
nnoremap <Leader>O O<Esc>

" Default width of the left column
set numberwidth=5

" Gutter Colors
hi LineNr ctermfg=15 ctermbg=236
hi CursorLineNr ctermfg=15 ctermbg=33

" Cursor line & column
set cursorcolumn
set cursorline
hi CursorLine ctermbg=235
hi CursorColumn ctermbg=235

" Move lines with arrow keys
" nnoremap <down> :m .+1<CR>==
" nnoremap <up> :m .-2<CR>==
" vnoremap <down> :m '>+1<CR>gv=gv
" vnoremap <up> :m '<-2<CR>gv=gv

" Make all files 2 space tab width
autocmd FileType * setlocal ts=2 sts=2 sw=2

" Hold onto undo history for everything
set noswapfile
set undodir=~/.vim/undodir
set undofile

" Split windows
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>
nnoremap <silent> <Leader>v :split<CR>
nnoremap <silent> <Leader>b :vsplit<CR>
nnoremap <silent> <Leader>q :close<CR>


"""""""""""""
"" PLUGINS ""
"""""""""""""

" Codi for code scratchpad
" nnoremap <Leader>irb :Codi ruby<CR>
" nnoremap <Leader>q :Codi!<CR>

" Indentline
" let g:indentLine_setColors = 0
" let g:indentLine_bgcolor_term = 233
" let g:indentLine_color_term = 236
" let g:indentLine_char = '|'
" let g:indentLine_setConceal = 0


" Sign Column
" let g:gitgutter_sign_column_always = 1
" set signcolumn=yes


" Supertab
let g:SuperTabDefaultCompletionType = "<c-n>"
let g:SuperTabCrMapping = 1

" Buffergator
let g:buffergator_suppress_keymaps = 1
nmap <leader>m :BuffergatorToggle<CR>

" GitGutter
nmap <silent> <leader>g :GitGutterToggle<CR>
let g:gitgutter_enabled = 0

" Git Messenger
let g:git_messenger_no_default_mappings=v:true
nmap <leader>gg <Plug>(git-messenger)

" NerdTree
let g:NERDTreeQuitOnOpen = 1
map <C-n> :NERDTreeToggle<CR>

" NerdCommenter
nnoremap <leader>cc NERDComToggleComment<CR>

" GOYO
" let g:goyo_width = 160
" let g:goyo_height = 120
" nnoremap <leader>gg :Goyo<CR>
" nnoremap <leader>go :Goyo!<CR>

" Closetag
let g:closetag_filenames = "*.html.erb,*.html,*.xhtml,*.phtml, *.js"

" Ale
map <leader>at :ALEToggle<CR>
" let g:ale_sign_column_always = 1
" let g:ale_fixers = {'ruby': ['ruby']}

" FZF
" let g:fzf_layout = { 'window': '10split' }
" Colors defined in .bashrc
" https://github.com/junegunn/fzf/wiki/Color-schemes
nnoremap <silent> <C-p> :FZF<CR>
nnoremap <silent>f :Ag<CR>
let g:fzf_layout = { 'down': '~60%' }

" Vim Fugitive
nnoremap <silent> <Leader>gb :Git blame<CR>

" Airline
let g:airline_theme='molokai'
let g:airline_powerline_fonts = 1 

" XTerm Color Table
nmap <silent> <Leader>ct :XtermColorTable<CR>

" TMUX
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif


" Things I want to try:
" These 2 packages require python 3 to run
" Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote') }
" Plug 'fishbullet/deoplete-ruby'
