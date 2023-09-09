imap <buffer> <C-x>= <%=  %><Left><Left><Left>
imap <buffer> <C-x>- <%  %><Left><Left><Left>

autocmd User ProjectionistDetect
      \ call projectionist#append(getcwd(), {
      \   'lib/*.ex': {
      \     'alternate': 'test/{}_test.exs',
      \     'type': 'source'
      \   },
      \   'test/*_test.exs': {
      \     'alternate': 'lib/{}.ex',
      \     'type': 'test'
      \   }
      \ })
