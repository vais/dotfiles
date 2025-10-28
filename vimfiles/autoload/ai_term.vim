if exists('g:loaded_ai_term')
  finish
endif
let g:loaded_ai_term = 1

let s:state = {'buf': -1, 'lnum': 1}
let s:selection = {'buf': -1, 'start': 0, 'end': 0}
let s:focus_tracking_setup = 0

function! ai_term#setup(config) abort
  if exists('b:ai_term_configured')
    return
  endif
  let b:ai_term_configured = 1

  call s:ensure_focus_tracking()

  let b:ai_term_prompt = get(a:config, 'prompt_pattern', '')

  setlocal termwinscroll=500
  execute 'setlocal termwinsize=' . winheight(0) . 'x' . winwidth(0)

  let &l:foldmethod = 'expr'
  let &l:foldexpr = "getline(v:lnum)=~b:ai_term_prompt&&(v:lnum==1||getline(v:lnum-1)!~b:ai_term_prompt)?'>1':1"
  setlocal foldtext=foldtext()

  call s:define_buffer_maps()
endfunction

function! ai_term#RecordRange(buf, start, end, range_count) abort
  if !s:is_file_buffer(a:buf)
    return
  endif
  if a:range_count > 0
    call s:store_selection(a:buf, a:start, a:end)
  else
    call s:clear_selection()
  endif
endfunction

function! ai_term#OpenTerminalSession(session, line1, line2, range_count, qargs) abort
  let l:buf = bufnr('%')
  call ai_term#RecordRange(l:buf, a:line1, a:line2, a:range_count)

  let l:width = get(g:, 'ai_term_width', 100)
  let l:cmd = "vertical botright terminal ++cols=" . l:width . " " . a:session
  if !empty(a:qargs)
    let l:cmd .= ' ' . a:qargs
  endif

  execute l:cmd
  let l:term_buf = bufnr('%')
  execute 'set filetype=' . a:session

  " Give the terminal job a moment to start before sending context.
  let l:delay = get(g:, 'ai_term_send_delay_ms', 1000)
  call timer_start(l:delay, {tid -> ai_term#SendLastFocusedLocation(1, l:term_buf)})
endfunction

function! ai_term#SendLastFocusedLocation(...) abort
  let l:force_send = a:0 >= 1 ? a:1 : 0
  let l:target_buf = a:0 >= 2 ? a:2 : bufnr('%')

  let l:path = s:get_last_focused_location()
  if empty(l:path)
    return ''
  endif

  if l:target_buf <= 0 || !bufexists(l:target_buf)
    return ''
  endif

  if !l:force_send && mode(1) =~# '^t'
    return l:path
  endif

  if exists('*term_sendkeys')
    call term_sendkeys(l:target_buf, l:path)
  else
    echoerr 'Sending text to the terminal is not supported in this Vim'
  endif

  return ''
endfunction

function! s:ensure_focus_tracking() abort
  if s:focus_tracking_setup
    return
  endif
  let s:focus_tracking_setup = 1

  augroup AiTermFocusTracking
    autocmd!
    autocmd BufEnter * call s:record_focus()
    autocmd BufLeave * call s:record_focus()
    autocmd ModeChanged * call s:handle_mode_changed()
  augroup END

  call s:seed_state()
endfunction

function! s:define_buffer_maps() abort
  cnoremap <buffer> e<CR> <CR>

  augroup AiTermFolding
    autocmd! * <buffer>
    autocmd ModeChanged <buffer> if mode() ==# 'n' | setlocal foldmethod=expr | endif
  augroup END

  nmap <buffer> <C-n> zj
  nnoremap <buffer> <expr> <C-p> line('.') == line('$') ? '[z' : 'zk[z'

  tmap <buffer> <C-w>K <C-w>K
  tmap <buffer> <C-w>J <C-w>J

  tnoremap <silent> <expr> <buffer> <C-w>f ai_term#SendLastFocusedLocation()
endfunction

function! s:get_last_focused_location() abort
  let l:candidates = [s:state, {'buf': bufnr('#'), 'lnum': 0}]
  for l:item in l:candidates
    let l:buf = get(l:item, 'buf', -1)
    if !s:is_file_buffer(l:buf)
      continue
    endif

    let l:lnum = s:resolve_line(l:buf, get(l:item, 'lnum', 0))
    call s:set_focus(l:buf, l:lnum)

    let l:path = fnamemodify(bufname(l:buf), ':.')
    let l:range = s:take_selection(l:buf)
    if empty(l:range)
      let l:range = string(l:lnum)
    endif

    return l:path . ':' . l:range
  endfor

  echo 'No last focused file buffer'
  return ''
endfunction

function! s:is_file_buffer(buf) abort
  return a:buf > 0 && bufexists(a:buf) && getbufvar(a:buf, '&buftype') ==# '' && !empty(bufname(a:buf))
endfunction

function! s:set_focus(buf, lnum) abort
  if !s:is_file_buffer(a:buf)
    return
  endif
  let s:state = {'buf': a:buf, 'lnum': s:resolve_line(a:buf, a:lnum)}
endfunction

function! s:resolve_line(buf, lnum) abort
  let l:value = a:lnum > 0 ? a:lnum : 0

  if l:value <= 0
    let l:info = getbufinfo({'bufnr': a:buf})
    if !empty(l:info)
      let l:value = get(l:info[0], 'lnum', 0)
    endif
  endif

  if l:value <= 0
    for l:win in getwininfo()
      if get(l:win, 'bufnr', -1) == a:buf
        let l:winid = get(l:win, 'winid', 0)
        if l:winid > 0
          let l:value = line('.', l:winid)
          if l:value > 0
            break
          endif
        endif
      endif
    endfor
  endif

  if l:value <= 0
    for l:mark in getmarklist(a:buf)
      if get(l:mark, 'mark', '') ==# '"'
        let l:pos = get(l:mark, 'pos', [])
        if len(l:pos) >= 2
          let l:value = l:pos[1]
          break
        endif
      endif
    endfor
  endif

  return l:value > 0 ? l:value : 1
endfunction

function! s:take_selection(buf) abort
  if get(s:selection, 'buf', -1) != a:buf
    return ''
  endif

  let l:start = get(s:selection, 'start', 0)
  let l:end = get(s:selection, 'end', 0)
  call s:clear_selection()

  if l:start <= 0 || l:end <= 0
    return ''
  endif

  if l:end < l:start
    let [l:start, l:end] = [l:end, l:start]
  endif

  if l:start == l:end
    return string(l:start)
  endif

  return l:start . '-' . l:end
endfunction

function! s:record_focus() abort
  if &buftype ==# '' && !empty(bufname('%'))
    call s:set_focus(bufnr('%'), line('.'))
  endif
endfunction

function! s:handle_mode_changed() abort
  if !exists('v:event')
    return
  endif
  let l:old_mode = get(v:event, 'old_mode', '')
  if index(['v', 'V', "\<C-v>"], l:old_mode) >= 0
    call s:remember_visual_selection()
  endif
endfunction

function! s:remember_visual_selection() abort
  let l:buf = bufnr('%')
  if !s:is_file_buffer(l:buf)
    return
  endif
  let l:start = line("'<")
  let l:end = line("'>")
  call s:store_selection(l:buf, l:start, l:end)
endfunction

function! s:seed_state() abort
  let l:latest = {'buf': -1, 'lnum': 0, 'lastused': -1}
  for l:info in getbufinfo({'buflisted': 1})
    let l:buf = get(l:info, 'bufnr', -1)
    if !s:is_file_buffer(l:buf)
      continue
    endif

    let l:lastused = get(l:info, 'lastused', -1)
    if l:lastused < 0
      continue
    endif

    if l:lastused < get(l:latest, 'lastused', -1)
      continue
    endif

    let l:latest = {'buf': l:buf, 'lnum': get(l:info, 'lnum', 0), 'lastused': l:lastused}
  endfor

  if get(l:latest, 'buf', -1) > 0
    call s:set_focus(l:latest.buf, l:latest.lnum)
  endif
endfunction

function! s:store_selection(buf, start, end) abort
  if a:start <= 0 || a:end <= 0
    call s:clear_selection()
    return
  endif

  let l:start = a:start
  let l:end = a:end
  if l:end < l:start
    let [l:start, l:end] = [l:end, l:start]
  endif

  let s:selection = {'buf': a:buf, 'start': l:start, 'end': l:end}
endfunction

function! s:clear_selection() abort
  let s:selection = {'buf': -1, 'start': 0, 'end': 0}
endfunction
