setlocal makeprg=eslint\ --format\ unix\ \"%\"
nmap <buffer> <silent> <F5> :update<Bar>exe ":silent lmake!"<Bar>lwindow5<CR>
