setlocal makeprg=ruby\ -cwW2\ \"%\"
nmap <buffer> <silent> <F5> :update<Bar>exe ":silent lmake!"<Bar>lwindow5<CR>

iabbr <buffer> pry require 'pry'; binding.pry 
iabbr <buffer> irb require 'irb'; binding.irb 
