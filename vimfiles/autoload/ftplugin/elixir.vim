function ftplugin#elixir#ElixirTags()
  let mix_file = findfile('mix.exs', '.;')
  if empty(mix_file)
    echohl WarningMsg
    echomsg 'mix.exs not found'
    echohl None
  else
    let tags_file = fnamemodify(mix_file, ':p:s?mix.exs$?tags?')
    let lib_dir = fnamemodify(mix_file, ':p:s?mix.exs$?lib?')
    let cmd = '!ctags -f "' . tags_file . '" -R "' . lib_dir . '"'
    echomsg cmd
    silent exe cmd
  endif
endfunction
