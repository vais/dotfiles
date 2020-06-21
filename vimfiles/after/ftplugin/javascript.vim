" Abbreviate console.log as clo (use Space or CTRL-] to expand the abbrev)
iabbr <buffer> clo console.log();<left><left>

" Map Leader-v to paste a path from system clipboard as relative to current file:
nmap <buffer> <silent> <Leader>v a<C-r>=system("node -e \"process.stdout.write(path.relative('" . expand('%:p:h') . "', '" . fnamemodify(@+, ':r') . "'))\"")<CR><Esc>
