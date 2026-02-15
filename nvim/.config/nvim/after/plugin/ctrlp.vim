" CtrlP custom statusline functions.
if !exists('g:loaded_ctrlp') || !g:loaded_ctrlp
  finish
endif

let g:ctrlp_status_func = {
  \ 'main': 'CtrlP_Statusline_1',
  \ 'prog': 'CtrlP_Statusline_2',
  \ }

" Arguments: focus, byfname, regexp, prev, item, next, marked
function! CtrlP_Statusline_1(...) abort
  let byfname = '%#LineNr# ' . a:2 . ' %*'
  let regex = a:3 ? '%#LineNr# regex %*' : '%#LineNr# plain %*'
  let item = '%#Character# ' . a:5 . ' '
  let dir = ' %=%<%#LineNr# ' . getcwd() . ' %*'

  return regex . byfname . item . dir
endfunction

" Argument: len
function! CtrlP_Statusline_2(...) abort
  let len = '%#Character# ' . a:1 . ' %*'
  let dir = ' %=%<%#LineNr# ' . getcwd() . ' %*'

  return len . dir
endfunction
