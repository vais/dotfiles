setlocal omnifunc=vim_dadbod_completion#omni

imap <buffer> <expr> <C-@> ((pumvisible())?("\<C-n>"):("\<C-x><C-o>"))
imap <buffer> <expr> <C-Space> ((pumvisible())?("\<C-n>"):("\<C-x><C-o>"))

" requires npm install sql-formatter
nmap <buffer> <silent> <Leader>F :%!sql-formatter -l sql<CR>
vmap <buffer> <silent> <Leader>F :!sql-formatter -l sql<CR>
