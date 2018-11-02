function! PackInit() abort
  packadd minpac

  call minpac#init()
  call minpac#add('k-takata/minpac', {'type': 'opt'})

  " Additional plugins here.
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
hi LineNr ctermbg=NONE
hi NonText ctermbg=NONE
hi Normal ctermbg=NONE
hi Visual ctermfg=235 ctermbg=189 cterm=NONE guifg=#192224 guibg=#F9F9FF guisp=#F9F9FF gui=NONE

let vim_session_dir=expand("~/.vim/session/")

if !isdirectory(vim_session_dir)
    call mkdir(vim_session_dir, "p")
endif

execute "set backupdir=".vim_session_dir.",/tmp/"
execute "set directory=".vim_session_dir.",/tmp/"
execute "set undodir=".vim_session_dir.",/tmp/"

set ignorecase
set smartcase
set incsearch
set hlsearch

set mouse=vi

if has("gui_running")
  set clipboard=unnamedplus
else
  set clipboard=unnamed
endif

" autocmd InsertEnter,InsertLeave * set cul!

nmap <S-Enter> O<Esc>
nmap <CR> o<Esc>

map <C-n> :NERDTreeToggle<CR>
map <C-p> :Files<CR>

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
