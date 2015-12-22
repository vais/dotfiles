setlocal makeprg=jshint
\\ --reporter=unix
\\ \"%\"

nnoremap <buffer> <silent> <F5> :update<Bar>exe ":silent lmake!"<Bar>lwindow5<CR>
imap <buffer> <silent> <F5> <Esc><F5>
