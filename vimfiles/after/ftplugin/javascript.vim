setlocal makeprg=jshint
\\ --reporter=unix
\\ \"%\"

nnoremap <buffer> <silent> <F5> :update<Bar>exe ":silent lmake!"<Bar>lwindow5<CR>
imap <buffer> <silent> <F5> <Esc><F5>

vmap <buffer> <silent> gfe :<C-u>let @t=@@<CR>gvy:<C-U>edit <C-R><C-R>=substitute(substitute(substitute(substitute(@@, '\.', '/', 'g'), 'Rapid/', 'src/app/', ''), 'Ext/', 'lib/ext-4.0.7-gpl/src/', ''), 'Extensible/', 'lib/extensible-1.5.1/src/', '')<CR>.js<CR>:let @@=@t<CR>
vmap <buffer> <silent> gfs :<C-u>let @t=@@<CR>gvy:<C-U>split <C-R><C-R>=substitute(substitute(substitute(substitute(@@, '\.', '/', 'g'), 'Rapid/', 'src/app/', ''), 'Ext/', 'lib/ext-4.0.7-gpl/src/', ''), 'Extensible/', 'lib/extensible-1.5.1/src/', '')<CR>.js<CR>:let @@=@t<CR>
vmap <buffer> <silent> gfv :<C-u>let @t=@@<CR>gvy:<C-U>vsplit <C-R><C-R>=substitute(substitute(substitute(substitute(@@, '\.', '/', 'g'), 'Rapid/', 'src/app/', ''), 'Ext/', 'lib/ext-4.0.7-gpl/src/', ''), 'Extensible/', 'lib/extensible-1.5.1/src/', '')<CR>.js<CR>:let @@=@t<CR>
vmap <buffer> <silent> gft :<C-u>let @t=@@<CR>gvy:<C-U>tabedit <C-R><C-R>=substitute(substitute(substitute(substitute(@@, '\.', '/', 'g'), 'Rapid/', 'src/app/', ''), 'Ext/', 'lib/ext-4.0.7-gpl/src/', ''), 'Extensible/', 'lib/extensible-1.5.1/src/', '')<CR>.js<CR>:let @@=@t<CR>
