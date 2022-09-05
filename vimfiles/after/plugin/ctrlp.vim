" Adapted from https://gist.github.com/1610859

" File: after/plugin/ctrlp.vim
" Description: Custom statusline example

" Make sure ctrlp is installed and loaded
if !exists('g:loaded_ctrlp') || ( exists('g:loaded_ctrlp') && !g:loaded_ctrlp )
	fini
en

" ctrlp only looks for this
let g:ctrlp_status_func = {
	\ 'main': 'CtrlP_Statusline_1',
	\ 'prog': 'CtrlP_Statusline_2',
	\ }

" Arguments: focus, byfname, s:regexp, prv, item, nxt, marked
"            a:1    a:2      a:3       a:4  a:5   a:6  a:7
fu! CtrlP_Statusline_1(...)
	let byfname = '%#LineNr# '.a:2.' %*'
	let regex = a:3 ? '%#LineNr# regex %*' : '%#LineNr# plain %*'
	let item = '%#Character# '.a:5.' '
	let dir = ' %=%<%#LineNr# '.getcwd().' %*'
	" Return the full statusline
	retu regex.byfname.item.dir
endf

" Argument: len
"           a:1
fu! CtrlP_Statusline_2(...)
	let len = '%#Character# '.a:1.' %*'
	let dir = ' %=%<%#LineNr# '.getcwd().' %*'
	" Return the full statusline
	retu len.dir
endf
