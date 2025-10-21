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
    if has('unix')
        if filereadable('/proc/version')
            let proc_version = readfile('/proc/version')[0]
            if proc_version =~? 'microsoft\|wsl'
                return 1
            endif
        endif
        
        if exists('$WSL_DISTRO_NAME') || exists('$WSLENV')
            return 1
        endif
        
        if isdirectory('/mnt/c')
            return 1
        endif
    endif
    return 0
endfunction

" Clipboard functions
function! ClipboardYank()
    if IsWSL()
        call system('/mnt/c/Windows/System32/clip.exe', @")
    elseif executable('xclip')
        call system('xclip -selection clipboard', @")
    endif
endfunction

function! ClipboardPaste()
    if executable('xclip') && !IsWSL()
        let @" = system('xclip -selection clipboard -o')
    endif
endfunction

" Configure clipboard based on capabilities
if has('clipboard')
    set clipboard=unnamedplus
else
    " Use our custom clipboard functions
    augroup CustomClipboard
        autocmd!
        " Automatically copy yanks to system clipboard
        autocmd TextYankPost * if v:event.operator ==# 'y' | call ClipboardYank() | endif
    augroup END
    
    " Clipboard mappings
    vnoremap <leader>y y:call ClipboardYank()<CR>
    nnoremap <leader>y y:call ClipboardYank()<CR>
    nnoremap <leader>Y yy:call ClipboardYank()<CR>
    nnoremap <leader>p :call ClipboardPaste()<CR>p
    vnoremap <leader>p d:call ClipboardPaste()<CR>p
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
call plug#end()


nnoremap <leader>e :NERDTreeToggle<CR>
let NERDTreeIgnore=['\.pyc$', '\.pyo$', '__pycache__', '\.git$']

nnoremap <leader>f :Files<CR>
