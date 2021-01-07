function s:VimPlugInit() 
  " auto install plug
  if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif

  " Plugins will be downloaded under the specified directory.
  call plug#begin('~/.vim/plugged')

  " very basic
  Plug 'tpope/vim-sensible'
  " surround cs/ds
  Plug 'tpope/vim-surround'
  " git plugins
  Plug 'tpope/vim-fugitive'
  Plug 'airblade/vim-gitgutter'
  " theme
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'dikiaap/minimalist'
  " comments with gc/gcc
  Plug 'tpope/vim-commentary'
  " Unix helpers Find, Delete, Mkdir, Move, Clocate, Chmod, SudoWrite,
  " SudoEdit, etc
  Plug 'tpope/vim-eunuch'
  " emmet helpers - Ctrl +y
  Plug 'mattn/emmet-vim'
  " misc
  Plug 'ervandew/supertab'
  Plug 'mhinz/vim-startify'

  let s:fzf_vim_file="/usr/share/doc/fzf/examples/plugin/fzf.vim"
  if filereadable(s:fzf_vim_file)
    exe "source " . s:fzf_vim_file
    Plug 'junegunn/fzf.vim'
  endif

  call plug#end()
endfunction

call s:VimPlugInit()

let g:airline_theme='minimalist'
silent! colorscheme minimalist
syntax on

" Clear the background so that it works
" well with transparency.
hi LineNr ctermbg=NONE
hi NonText ctermbg=NONE
hi Normal ctermbg=NONE
hi Visual ctermfg=235 ctermbg=189 cterm=NONE guifg=#192224 guibg=#F9F9FF guisp=#F9F9FF gui=NONE

" Setup vim session paths. This avoids polluting working dir
" and keeps things clean and organized
let vim_session_dir=expand("~/.vim/session/")
if !isdirectory(vim_session_dir)
    call mkdir(vim_session_dir, "p")
endif
execute "set backupdir=".vim_session_dir.",/tmp/"
execute "set directory=".vim_session_dir.",/tmp/"
execute "set undodir=".vim_session_dir.",/tmp/"

" Some sensible defaults
set ttymouse=xterm2
set mouse=a "a, vi
set ignorecase
set smartcase
set incsearch
set hlsearch
set shiftwidth=4
set expandtab


" netrw
let g:netrw_banner = 1
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_preview = 1
let g:netrw_altv = 0
let g:netrw_alto = 0
let g:netrw_winsize = 25

" Autoload project drawer
"
" augroup ProjectDrawer
"     autocmd!
"     autocmd VimEnter * :Vexplore
" augroup END

" Use gui clipboard only when running as gui (gvim, etc).
" Otherwise, simply be explict about what registers to use.
" This allows better flexibility on pseudo terminals like
" gnome-terminal.
if has("gui_running")
  set clipboard=unnamedplus
else
  set clipboard=unnamed
endif

" o/O inserts a new line after/before current,
" but enters insert mode. This allows Shift+Enter/CR
" to do this without entering insert mode.
nmap <S-Enter> O<Esc>
nmap <CR> o<Esc>

" External shortcuts
" map <C-n> :NERDTreeToggle<CR>
map <C-p> :Files<CR> " fzf

" Switch cursor indication for insert mode/normal mode
" autocmd InsertEnter,InsertLeave * set cul!

" Change cursor shape in different modes for gnome-Terminal
if has("autocmd")
  au VimEnter,InsertLeave * silent execute '!echo -ne "\e[2 q"' | redraw!
  au InsertEnter,InsertChange *
    \ if v:insertmode == 'i' | 
    \   silent execute '!echo -ne "\e[6 q"' | redraw! |
    \ elseif v:insertmode == 'r' |
    \   silent execute '!echo -ne "\e[4 q"' | redraw! |
    \ endif
  au VimLeave * silent execute '!echo -ne "\e[ q"' | redraw!
endif
