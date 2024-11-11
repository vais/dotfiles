iabbr <buffer> pry require 'pry'; binding.pry 
iabbr <buffer> irb require 'irb'; binding.irb 

call textobj#user#plugin('ruby', {
      \   'interpolation': {
      \     'pattern': ['#{', '}'],
      \     'select-a': '<buffer> ao',
      \     'select-i': '<buffer> io',
      \   },
      \ })
