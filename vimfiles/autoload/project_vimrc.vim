function project_vimrc#SourceProjectVimrc()
  let dot_vimrc = findfile('.vimrc', '.;')
  if empty(dot_vimrc)
    echohl WarningMsg
    echomsg '.vimrc not found'
    echohl None
  else
    let cmd = 'source ' . dot_vimrc
    echomsg cmd
    exe cmd
  endif
endfunction
