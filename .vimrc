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

let mapleader = " "

set incsearch
set showmatch
set ignorecase
set smartcase
nnoremap <leader>h :set hlsearch!<CR>

set showmode
set showcmd
set history=1000

set splitbelow
set splitright
set mouse=a


set wildmenu
set wildmode=list:longest
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx



set undofile
set undodir=~/.vim/undodir
" Create undo dir if it doesn't exist
if !isdirectory(expand('~/.vim/undodir'))
    call mkdir(expand('~/.vim/undodir'), 'p')
endif



nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <leader>j :m .+1<CR>==
nnoremap <leader>k :m .-2<CR>==
vnoremap <leader>j :m '>+1<CR>gv=gv
vnoremap <leader>k :m '<-2<CR>gv=gv

nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>s :wq<CR>


colorscheme slate


" ------------Clipboard Configuration START---------------

" WSL Detection 
function! IsWSL()
    if has('unix') && filereadable('/proc/version')
        let proc_version = readfile('/proc/version')[0]
        if proc_version =~? 'microsoft\|wsl'
            return 1
        endif
    endif
    return 0
endfunction

" 1. Handle WSL First (Bypass +clipboard trap)
if IsWSL()
    vnoremap <leader>y y:<C-u>call system('/mnt/c/Windows/System32/clip.exe', @")<CR>
    nnoremap <leader>yy yy:call system('/mnt/c/Windows/System32/clip.exe', @")<CR>
    " Use Vim's native substitute() instead of a shell pipe to strip carriage returns
    nnoremap <leader>p :let @" = substitute(system('powershell.exe -NoProfile -Command Get-Clipboard'), '\r', '', 'g')<CR>p
    vnoremap <leader>p :<C-u>let @" = substitute(system('powershell.exe -NoProfile -Command Get-Clipboard'), '\r', '', 'g')<CR>p

" 2. Handle Native Clipboard Support (Mac/Linux)
elseif has('clipboard')
    if has('macunix') || has('mac')
        " macOS uses the * register
        set clipboard=unnamed
    else
        " Linux uses the + register
        set clipboard=unnamedplus
    endif

" 3. Handle Fallbacks if no +clipboard (Mac/Linux)
else
    if executable('pbcopy')
        " macOS Fallbacks
        vnoremap <leader>y y:<C-u>call system('pbcopy', @")<CR>
        nnoremap <leader>yy yy:call system('pbcopy', @")<CR>
        nnoremap <leader>p :let @" = system('pbpaste')<CR>p
        vnoremap <leader>p :<C-u>let @" = system('pbpaste')<CR>p
    elseif executable('xclip')
        " Linux Fallbacks
        vnoremap <leader>y y:<C-u>call system('xclip -selection clipboard', @")<CR>
        nnoremap <leader>yy yy:call system('xclip -selection clipboard', @")<CR>
        nnoremap <leader>p :let @" = system('xclip -selection clipboard -o')<CR>p
        vnoremap <leader>p :<C-u>let @" = system('xclip -selection clipboard -o')<CR>p
    endif
endif

" ------------Clipboard Configuration END-----------------


" ------------Plugin Section---------------

" Ensure that vim-plug is installed
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC | quit
endif


call plug#begin()
    Plug 'preservim/nerdtree'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'preservim/nerdcommenter'
    Plug 'ojroques/vim-oscyank'
call plug#end()


nnoremap <leader>e :NERDTreeToggle<CR>
let NERDTreeIgnore=['\.pyc$', '\.pyo$', '__pycache__', '\.git$']

nnoremap <leader>f :Files<CR>

"---Fixing copying over tmux/ssh
autocmd TextYankPost * if v:event.operator is 'y' | execute 'OSCYankRegister ' . (empty(v:event.regname) ? '"' : v:event.regname) | endif
