" Map Leader-v to paste a path from system clipboard as relative to current file:
nmap <buffer> <silent> \v a<C-r>=system("node -e \"process.stdout.write(path.relative('" . expand('%:p:h') . "', '" . fnamemodify(@+, ':r') . "'))\"")<CR><Esc>

call textobj#user#plugin('javascript', {
      \   'interpolation': {
      \     'pattern': ['${', '}'],
      \     'select-a': '<buffer> ao',
      \     'select-i': '<buffer> io',
      \   },
      \ })
