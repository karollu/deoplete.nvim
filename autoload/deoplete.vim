"=============================================================================
" FILE: deoplete.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

function! deoplete#initialize() abort
  return deoplete#init#_initialize()
endfunction
function! deoplete#enable() abort
  if deoplete#initialize()
    return 1
  endif
  return deoplete#init#_enable()
endfunction
function! deoplete#disable() abort
  return deoplete#init#_disable()
endfunction
function! deoplete#toggle() abort
  return deoplete#init#_is_enabled() ?
        \ deoplete#disable() : deoplete#enable()
endfunction

function! deoplete#enable_logging(level, logfile) abort
  if !exists('g:deoplete#_channel_id')
    " Enable to allow logging before completions start.
    if deoplete#init#_channel()
      return
    endif
  endif

  call rpcnotify(g:deoplete#_channel_id,
        \ 'deoplete_enable_logging', a:level, a:logfile)
endfunction

function! deoplete#manual_complete(...) abort
  if deoplete#initialize()
    return
  endif

  " Start complete.
  return "\<C-r>=deoplete#mapping#_rpcrequest_wrapper("
        \ . string(get(a:000, 0, [])) . ")\<CR>"
endfunction
function! deoplete#close_popup() abort
  call deoplete#handler#_skip_next_completion()
  return pumvisible() ? "\<C-y>" : ''
endfunction
function! deoplete#smart_close_popup() abort
  call deoplete#handler#_skip_next_completion()
  return pumvisible() ? "\<C-e>" : ''
endfunction
function! deoplete#cancel_popup() abort
  return pumvisible() ? "\<C-e>" : ''
endfunction
function! deoplete#refresh() abort
  if exists('g:deoplete#_context')
    if get(g:deoplete#_context, 'event', '') ==# 'Manual'
      let g:deoplete#_context.event = 'Refresh'
    endif
  endif
  return pumvisible() ? "\<C-e>" : ''
endfunction
function! deoplete#undo_completion() abort
  return deoplete#mapping#_undo_completion()
endfunction
function! deoplete#complete_common_string() abort
  return deoplete#mapping#_complete_common_string()
endfunction
