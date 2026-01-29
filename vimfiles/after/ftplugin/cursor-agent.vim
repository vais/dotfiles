call ai_term#setup({'prompt_pattern': '^ │ '})

" Temporarily neuter <C-d> in Cursor:
" (hopefully they will fix forward delete, so we can remap in the future)
tmap <buffer> <C-d> <nop>

" ============================================
" ==[ CUT HERE WHEN CURSOR SUPPORTS IMAGES ]==
" ==[               8<  8<  8<             ]==
" ============================================
" Cursor-agent workaround: paste clipboard image as temp file path.
function! s:send_bracketed_paste(buf, text) abort
  if !exists('*term_getjob') || !exists('*job_getchannel') || !exists('*ch_sendraw')
    return 0
  endif

  let l:job = term_getjob(a:buf)
  if type(l:job) != v:t_job || job_status(l:job) !=# 'run'
    return 0
  endif

  let l:chan = job_getchannel(l:job)
  if type(l:chan) != v:t_channel || index(['open', 'buffered'], ch_status(l:chan)) < 0
    return 0
  endif

  call ch_sendraw(l:chan, "\x1b[200~" . a:text . "\x1b[201~")
  return 1
endfunction

function! s:send_text(buf, text) abort
  if s:send_bracketed_paste(a:buf, a:text)
    return
  endif

  if exists('*term_sendkeys')
    call term_sendkeys(a:buf, a:text)
  endif
endfunction

function! s:send_ctrl_v(buf) abort
  if exists('*term_sendkeys')
    call term_sendkeys(a:buf, "\x16")
  endif
endfunction

function! s:write_clipboard_image(path) abort
  if !executable('osascript')
    return 0
  endif

  let l:escaped_path = substitute(a:path, '["\\]', '\\\0', 'g')
  let l:script = [
        \ 'set theImage to the clipboard as «class PNGf»',
        \ 'set outFile to (POSIX file "' . l:escaped_path . '")',
        \ 'set outRef to open for access outFile with write permission',
        \ 'set eof outRef to 0',
        \ 'write theImage to outRef',
        \ 'close access outRef',
        \ ]
  let l:cmd = 'osascript'
  for l:line in l:script
    let l:cmd .= ' -e ' . shellescape(l:line)
  endfor

  call system(l:cmd)
  return v:shell_error == 0
endfunction

function! s:paste_text_or_image_path() abort
  let l:target_buf = bufnr('%')
  if l:target_buf <= 0 || !bufexists(l:target_buf)
    return ''
  endif

  let l:text = getreg('+')
  if strlen(l:text) > 0
    call s:send_text(l:target_buf, l:text)
    return ''
  endif

  let l:path = tempname() . '.png'
  if s:write_clipboard_image(l:path)
    call s:send_text(l:target_buf, l:path)
    return ''
  endif

  call delete(l:path)
  call s:send_ctrl_v(l:target_buf)
  return ''
endfunction

tnoremap <silent> <buffer> <C-v> <C-\><C-n>:call <SID>paste_text_or_image_path()<CR>i
tnoremap <silent> <buffer> <D-v> <C-\><C-n>:call <SID>paste_text_or_image_path()<CR>i
" ============================================
" ==[            END CUT SECTION           ]==
" ==[               8<  8<  8<             ]==
" ============================================
