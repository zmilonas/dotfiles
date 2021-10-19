set nocompatible              " be iMproved, required
syntax enable
set expandtab
set showcmd
set cursorline
set wildmenu
set number relativenumber
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-fugitive'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

