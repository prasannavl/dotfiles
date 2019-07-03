function! PackInit() abort
  " Setup minpac
  packadd minpac
  call minpac#init()
  call minpac#add('k-takata/minpac', {'type': 'opt'})

  " Additional plugins here.
  call minpac#add('tpope/vim-sensible')
  call minpac#add('tpope/vim-surround')
  call minpac#add('tpope/vim-fugitive')
  call minpac#add('vim-airline/vim-airline')
  call minpac#add('vim-airline/vim-airline-themes')
  call minpac#add('tpope/vim-commentary')
  call minpac#add('scrooloose/nerdtree')
  call minpac#add('dikiaap/minimalist')
  call minpac#add('junegunn/fzf.vim')
  call minpac#add('tpope/vim-eunuch')
  call minpac#add('mattn/emmet-vim')
  call minpac#add('airblade/vim-gitgutter')
  call minpac#add('ervandew/supertab')
  call minpac#add('mhinz/vim-startify')
endfunction

" Plugin settings here.

" Define user commands for updating/cleaning the plugins.
" Each of them calls PackInit() to load minpac and register
" the information of plugins, then performs the task.
command! PackUpdate call PackInit() | call minpac#update('', {'do': 'call minpac#status()'})
command! PackClean  call PackInit() | call minpac#clean()
command! PackStatus call PackInit() | call minpac#status()

let g:airline_theme='minimalist'
colorscheme minimalist
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
set mouse=vi
set ignorecase
set smartcase
set incsearch
set hlsearch
set shiftwidth=4
set expandtab

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

" Setup file explorer shortcuts
map <C-n> :NERDTreeToggle<CR>
map <C-p> :Files<CR>

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
