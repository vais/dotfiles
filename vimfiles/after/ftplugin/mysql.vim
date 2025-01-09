setlocal omnifunc=vim_dadbod_completion#omni

imap <buffer> <expr> <C-@> ((pumvisible())?("\<C-n>"):("\<C-x><C-o>"))
imap <buffer> <expr> <C-Space> ((pumvisible())?("\<C-n>"):("\<C-x><C-o>"))
