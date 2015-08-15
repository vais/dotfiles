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
	let focus = ' '.a:1.' %*'
	let byfname = ' '.a:2.' %*'
	let regex = a:3 ? 'regex %*' : ''
	let prv = ' <'.a:4.'>='
	let item = '{ '.a:5.' %*}'
	let nxt = '=<'.a:6.'>'
	let marked = ' '.a:7.' '
	let dir = ' %=%< '.getcwd().' %*'
	" Return the full statusline
	retu focus.byfname.regex.prv.item.nxt.marked.dir
endf

" Argument: len
"           a:1
fu! CtrlP_Statusline_2(...)
	let len = ' '.a:1.' %*'
	let dir = ' %=%< '.getcwd().' %*'
	" Return the full statusline
	retu len.dir
endf
