nunmap <buffer> a
nmap <buffer> - =

nmap <buffer> <C-n> ]m>
nmap <buffer> <C-p> [m>

nmap <buffer> <C-s> s>

nmap <buffer> q gq

nmap <buffer><C-a> :let b:git_diff_opts_context = get(b:, 'git_diff_opts_context', 3) + 1<Bar>let $GIT_DIFF_OPTS="--unified=".b:git_diff_opts_context<Bar>e<Bar>let $GIT_DIFF_OPTS=""<CR>
nmap <buffer><C-x> :let b:git_diff_opts_context = max([get(b:, 'git_diff_opts_context', 3), 4]) - 1<Bar>let $GIT_DIFF_OPTS="--unified=".b:git_diff_opts_context<Bar>e<Bar>let $GIT_DIFF_OPTS=""<CR>
