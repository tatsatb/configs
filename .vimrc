filetype on
filetype plugin on
filetype indent on


syntax on

set number
set relativenumber

set cursorline


set shiftwidth=4
set tabstop=4

set expandtab

set incsearch
set showmatch

set showmode
set showcmd
set history=1000


set wildmenu
set wildmode=list:longest
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

colorscheme slate

set clipboard=unnamedplus

" For WSL2 Clipboard
let s:clip = '/mnt/c/Windows/System32/clip.exe'  " change this path according to your mount point
if executable(s:clip)
    augroup WSLYank
        autocmd!
        autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
    augroup END
endif
