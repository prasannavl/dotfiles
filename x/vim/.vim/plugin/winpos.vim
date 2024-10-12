" Restore screen size and position
" Saves data in a separate file, and so works with multiple instances of Vim.
if has("gui_running")
  function! ScreenFilename()
      return '~/.vim/session/winpos'
  endfunction

  function! ScreenRestore()
    " - Remembers and restores winposition, columns and lines stored in
    "   a .winpos file
    " - Must follow font settings so that columns and lines are accurate
    "   based on font size.
    if !has("gui_running")
      return
    endif
    if g:screen_size_restore_pos != 1
      return
    endif
    let vim_instance = (g:screen_size_by_vim_instance==1?(v:servername):'GVIM')
    " read any existing variables from .winpos file
    silent! execute "sview " . escape(ScreenFilename(),'%#\ $')
    silent! execute "0/^" . vim_instance . " /"
    let vim_name  = matchstr(getline('.'), '^\w\+')
    let vim_cols  = matchstr(getline('.'), '^\w\+\s\+\zs\d\+')
    let vim_lines = matchstr(getline('.'), '^\w\+\s\+\d\+\s\+\zs\d\+')
    let vim_posx  = matchstr(getline('.'), '^\w\+\s\+\d\+\s\+\d\+\s\+\zs\d\+')
    let vim_posy  = matchstr(getline('.'), '^\w\+\s\+\d\+\s\+\d\+\s\+\d\+\s\+\zs\d\+')
    if vim_name == vim_instance
      execute "set columns=".vim_cols
      execute "set lines=".vim_lines
      silent! execute "winpos ".vim_posx." ".vim_posy
    endif
    silent! q
  endfunction

  function! ScreenSave()
    " used on exit to retain window position and size
    if !has("gui_running")
      return
    endif
    if !g:screen_size_restore_pos
      return
    endif
    let vim_instance = (g:screen_size_by_vim_instance==1?(v:servername):'GVIM')
    silent! execute "split " . escape(ScreenFilename(),'%#\ $')
    silent! execute "0/^" . vim_instance . " /"
    let vim_name  = matchstr(getline('.'), '^\w\+')
    if vim_name == vim_instance
      delete _
    endif
    $put = vim_instance . ' ' . &columns . ' ' . &lines . ' ' .
          \ (getwinposx()<0?0:getwinposx()) . ' ' .
          \ (getwinposy()<0?0:getwinposy())
    silent! x!
  endfunction

  if !exists('g:screen_size_restore_pos')
    let g:screen_size_restore_pos = 1
  endif
  if !exists('g:screen_size_by_vim_instance')
    let g:screen_size_by_vim_instance = 1
  endif
  autocmd VimEnter * call ScreenRestore()
  autocmd VimLeavePre * call ScreenSave()
endif
