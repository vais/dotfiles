setlocal foldmethod=expr
setlocal foldexpr=getline(v:lnum)=~'^diff'?'>1':1
setlocal foldtext=foldtext()

nmap <buffer> <C-n> zmzjza
nmap <buffer> <C-p> zmzkza
