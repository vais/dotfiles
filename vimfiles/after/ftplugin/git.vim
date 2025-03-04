setlocal foldlevel=0
setlocal foldmethod=syntax
setlocal foldtext=foldtext()

nmap <buffer> - za
nmap <buffer> <nowait> = za

nmap <buffer> <C-n> zm]mza
nmap <buffer> <C-p> zm[mza

nmap <buffer> <silent> <C-a> :let b:git_diff_opts_context = get(b:, 'git_diff_opts_context', 3) + 1<Bar>let $GIT_DIFF_OPTS="--unified=".b:git_diff_opts_context<Bar>e<Bar>let $GIT_DIFF_OPTS=""<CR>zv
nmap <buffer> <silent> <C-x> :let b:git_diff_opts_context = max([get(b:, 'git_diff_opts_context', 3), 4]) - 1<Bar>let $GIT_DIFF_OPTS="--unified=".b:git_diff_opts_context<Bar>e<Bar>let $GIT_DIFF_OPTS=""<CR>zv
