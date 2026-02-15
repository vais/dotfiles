nunmap <buffer> a
nmap <buffer> - =

nmap <buffer> <C-n> ]m>
nmap <buffer> <C-p> [m>

nmap <buffer> <C-s> s>

nmap <buffer> q <C-w>c

nmap <buffer> <silent> <C-a> :let b:git_diff_opts_context = get(b:, 'git_diff_opts_context', 3) + 1<Bar>let $GIT_DIFF_OPTS="--unified=".b:git_diff_opts_context<Bar>e<Bar>let $GIT_DIFF_OPTS=""<CR>
nmap <buffer> <silent> <C-x> :let b:git_diff_opts_context = max([get(b:, 'git_diff_opts_context', 3), 4]) - 1<Bar>let $GIT_DIFF_OPTS="--unified=".b:git_diff_opts_context<Bar>e<Bar>let $GIT_DIFF_OPTS=""<CR>

" Map <Leader>l to:
" 1. reload git status
" 2. clear and redraw the screen
" 3. clear all inline diffs 
nmap <buffer> <silent> <Leader>l :call fugitive#ReloadStatus()<Bar>redraw!<CR>gg<

function! s:FugitiveGfCmd(mode) abort
  if !exists('*getscriptinfo')
    return ''
  endif

  let l:sid = 0
  for l:info in getscriptinfo()
    if get(l:info, 'name', '') =~# '/vim-fugitive/autoload/fugitive\.vim$'
      let l:sid = get(l:info, 'sid', 0)
      break
    endif
  endfor

  if l:sid <= 0
    return ''
  endif

  try
    let l:cmd = call(function('<SNR>' . l:sid . '_GF'), [a:mode])
  catch
    return ''
  endtry

  return type(l:cmd) == type('') ? l:cmd : ''
endfunction

function! s:FugitiveStatusOpen(keep_focus) abort
  if get(b:, 'fugitive_type', '') !=# 'index'
    return
  endif

  let l:cmd = s:FugitiveGfCmd('edit')
  if empty(l:cmd)
    return
  endif

  let l:status_win = win_getid()
  let l:target = -1

  if winnr('$') > 1
    let l:alt_nr = winnr('#')
    if l:alt_nr > 0
      let l:alt_id = win_getid(l:alt_nr)
      let [l:alt_tabnr, l:_] = win_id2tabwin(l:alt_id)
      if l:alt_id != l:status_win && l:alt_tabnr == tabpagenr()
        let l:target = l:alt_id
      endif
    endif

    if l:target == -1
      for l:nr in range(1, winnr('$'))
        let l:id = win_getid(l:nr)
        if l:id != l:status_win
          let l:target = l:id
          break
        endif
      endfor
    endif
  endif

  if l:target == -1
    rightbelow vsplit
  else
    call win_gotoid(l:target)
  endif

  execute l:cmd
  silent! normal! zz

  if a:keep_focus && win_id2win(l:status_win) > 0
    call win_gotoid(l:status_win)
  endif
endfunction

function! s:FugitiveStatusOpenMode(mode, keep_focus) abort
  if get(b:, 'fugitive_type', '') !=# 'index'
    return
  endif

  let l:cmd = s:FugitiveGfCmd(a:mode)
  if empty(l:cmd)
    return
  endif

  let l:status_win = win_getid()

  execute l:cmd
  silent! normal! zz

  if a:keep_focus && win_id2win(l:status_win) > 0
    call win_gotoid(l:status_win)
  endif
endfunction

function! s:ApplyFugitiveStatusOpenMappings() abort
  if get(b:, 'fugitive_type', '') !=# 'index'
    return
  endif

  nnoremap <buffer> <silent> <CR> :<C-U>call <SID>FugitiveStatusOpenMode("edit", 0)<CR>
  nnoremap <buffer> <silent> gO   :<C-U>call <SID>FugitiveStatusOpenMode("vsplit", 0)<CR>
  nnoremap <buffer> <silent> O    :<C-U>call <SID>FugitiveStatusOpenMode("tabedit", 0)<CR>
  silent! nunmap <buffer> o
  nnoremap <buffer> <silent> o  :<C-U>call <SID>FugitiveStatusOpen(0)<CR>
  nnoremap <buffer> <silent> <2-LeftMouse> :<C-U>call <SID>FugitiveStatusOpen(0)<CR>
  nnoremap <buffer> <silent> go :<C-U>call <SID>FugitiveStatusOpen(1)<CR>
endfunction

function! s:ApplyFugitiveStatusOpenMappingsDeferred(_timer) abort
  call s:ApplyFugitiveStatusOpenMappings()
endfunction

function! s:ScheduleFugitiveStatusOpenMappings() abort
  if exists('*timer_start')
    call timer_start(0, function('<SID>ApplyFugitiveStatusOpenMappingsDeferred'))
    call timer_start(30, function('<SID>ApplyFugitiveStatusOpenMappingsDeferred'))
    call timer_start(120, function('<SID>ApplyFugitiveStatusOpenMappingsDeferred'))
  else
    call s:ApplyFugitiveStatusOpenMappings()
  endif
endfunction

function! s:FugitiveStatusOnBufEnter() abort
  if get(b:, 'fugitive_auto_reload_running', 0)
    return
  endif

  let b:fugitive_auto_reload_running = 1
  silent! call fugitive#ReloadStatus()
  let b:fugitive_auto_reload_running = 0

  call s:ScheduleFugitiveStatusOpenMappings()
endfunction

call s:ScheduleFugitiveStatusOpenMappings()

augroup FugitiveAutoReloadStatus
  autocmd! * <buffer>
  autocmd User FugitiveIndex call <SID>ScheduleFugitiveStatusOpenMappings()
  autocmd BufEnter <buffer> call <SID>FugitiveStatusOnBufEnter()
augroup END
