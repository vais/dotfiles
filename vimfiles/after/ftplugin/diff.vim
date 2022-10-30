setlocal foldlevel=0
setlocal foldmethod=expr
setlocal foldexpr=getline(v:lnum)=~'^diff'?'>1':1
setlocal foldtext=foldtext()

nmap <buffer> <C-Space> za
nmap <buffer> <C-n> zmzjza
nmap <buffer> <C-p> zmzkza
