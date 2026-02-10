nunmap <buffer> a
nmap <buffer> - =

nmap <buffer> <C-n> ]m>
nmap <buffer> <C-p> [m>

nmap <buffer> <C-s> s>

nmap <buffer> q <C-w>c

nmap <buffer> <silent> <C-a> :let b:git_diff_opts_context = get(b:, 'git_diff_opts_context', 3) + 1<Bar>let $GIT_DIFF_OPTS="--unified=".b:git_diff_opts_context<Bar>e<Bar>let $GIT_DIFF_OPTS=""<CR>
nmap <buffer> <silent> <C-x> :let b:git_diff_opts_context = max([get(b:, 'git_diff_opts_context', 3), 4]) - 1<Bar>let $GIT_DIFF_OPTS="--unified=".b:git_diff_opts_context<Bar>e<Bar>let $GIT_DIFF_OPTS=""<CR>

" Map <Leader>l to:
" 1. reload git status
" 2. clear and redraw the screen
" 3. clear all inline diffs 
nmap <buffer> <silent> <Leader>l :call fugitive#ReloadStatus()<Bar>redraw!<CR>gg<

augroup FugitiveAutoReloadStatus
  autocmd! * <buffer>
  autocmd BufEnter <buffer> call fugitive#ReloadStatus()
augroup END
