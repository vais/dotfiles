nmap <buffer> <silent> <S-F5> :update<Bar>:call ftplugin#elixir#ElixirTags()<CR>

" To make project A's tags available in project B, add
" the following line of code to project B's .vimrc file:
"
" exe 'set tags+=' . expand('<sfile>:p:h') . '/ <RELATIVE/PATH/TO/PROJECT/A> /tags'

iabbr <buffer> pry require IEx; IEx.pry
iabbr <buffer> spry spawn(fn -> require IEx; IEx.pry end)
