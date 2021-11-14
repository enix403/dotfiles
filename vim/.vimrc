syntax on

filetype plugin indent on
set tabstop=4
set shiftwidth=4
set expandtab
set laststatus=2

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
