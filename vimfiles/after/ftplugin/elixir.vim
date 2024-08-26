imap <buffer> <C-x>= <%=  %><Left><Left><Left>
imap <buffer> <C-x>- <%  %><Left><Left><Left>

call textobj#user#plugin('elixir', {
      \   'map': {
      \     'pattern': ['%{', '}'],
      \     'select-a': '<buffer> am',
      \     'select-i': '<buffer> im',
      \   },
      \ })
