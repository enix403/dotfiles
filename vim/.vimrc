syntax on

filetype plugin indent on
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set laststatus=2
set hidden

" More config

set mouse=a
set number          " show line numbers
set noswapfile      " disable the swapfile
set hlsearch        " highlight all results
set ignorecase      " ignore case in search
set incsearch       " show search results as you type

noremap <silent> <C-S>          :update<CR>
vnoremap <silent> <C-S>         <C-C>:update<CR>
inoremap <silent> <C-S>         <C-O>:update<CR>

nnoremap <silent> <C-@> i

inoremap <C-S-K> <C-o>"_dd
noremap <C-S-K> "_dd

inoremap <C-S-D> <C-o>"lyy<C-o>"lp
noremap <C-S-D> "lyy"lp

inoremap jj <Esc>

inoremap <C-Left> <C-o>b<C-o>i
inoremap <C-Right> <C-o>e<C-o>a

noremap <C-Left> b
noremap <C-Right> e

let &t_EI = "\<Esc>[1 q"
let &t_SI = "\<Esc>[5 q"
let &t_SR = "\<Esc>[1 q"
let &t_VS = "\<Esc>[1 q"
autocmd VimLeave * silent !echo -ne "\033]112\007"

set ttimeout
set ttimeoutlen=1
set listchars=tab:>-,trail:~,extends:>,precedes:<,space:.
set ttyfast


" Allow saving of files as sudo when vim was not started with root privileges
cmap w!! w !sudo tee > /dev/null %


