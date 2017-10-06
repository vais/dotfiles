setlocal makeprg=rubocop\ --format=emacs\ \"%\"

nnoremap <buffer> <silent> <F5> :update<Bar>exe ":silent lmake!"<Bar>lwindow5<CR>
imap <buffer> <silent> <F5> <Esc><F5>

iabbr <buffer> pry require 'pry'; binding.pry 
iabbr <buffer> irb require 'irb'; binding.irb 
