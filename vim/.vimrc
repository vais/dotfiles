syntax enable                     " Turn on syntax highlighting.
filetype plugin indent on         " Turn on file type detection.

runtime macros/matchit.vim        " Load the matchit plugin.

set nocompatible                  " Must come first because it changes other options.
set encoding=utf-8                " Use UTF-8 encoding by default
set fileformats=unix,dos,mac      " Use Unix-style line endings by default
set shortmess+=I                  " No startup splashscreen please.
set modelines=0                   " Do not check *any* modlines for `set` commands.

set smartindent                   " Do smart autoindenting when starting a new line.
set autoindent                    " Copy indent from current line when starting a new line.

set showcmd                       " Display incomplete commands, number of selected chars/lines.
set showmode                      " Display the mode you're in.

set backspace=indent,eol,start    " Intuitive backspacing.

set hidden                        " Handle multiple buffers better.

set wildmenu                      " Enhanced command line completion.
set wildmode=list:longest         " Complete files like a shell.

set ignorecase                    " Case-insensitive searching.
set smartcase                     " But case-sensitive if expression contains a capital letter.

set number                        " Show line numbers.

set incsearch                     " Highlight first match as you type.
set nohlsearch                    " Do not highlight matches.

set nowrap                        " Turn off line wrapping.
set linebreak                     " Wrap at characters in 'breakat' rather than at the last character that fits on the screen.

set visualbell t_vb=              " No beeping and no flashing.

set nobackup                      " Don't make a backup before overwriting a file.
set nowritebackup                 " And again.
set noswapfile                    " Don't make swap files.

set virtualedit=block             " Allow virtual editing in Visual Block mode.

set smarttab                      " <Tab> in front of a line inserts blanks according to 'shiftwidth'.
set expandtab                     " Use the appropriate number of spaces to insert a <Tab>.
set shiftround                    " Round indent to multiple of 'shiftwidth'.
set tabstop=2                     " Number of spaces that a <Tab> in the file counts for.
set softtabstop=2                 " Number of spaces that a <Tab> counts for while performing editing operations.
set shiftwidth=2                  " Number of spaces to use for each step of (auto)indent.

set laststatus=2                  " Always show the status line.
set statusline=[%n]\ %<%.999f\ %h%w%1*%m%*%#error#%r%*

set complete=.,w,b                " Auto-complete from all currently loaded buffers.
set completeopt=menuone,noselect,noinsert

set history=1000                  " The number of commands and search patterns to keep in history.

set mouse=a                       " Enable the use of the mouse in all modes.

set noequalalways                 " Don't make all windows same size after splitting or closing a window.
set winminheight=1                " The minimal height of a window, when it's not the current window.
set winminwidth=1                 " The minimal width of a window, when it's not the current window.

let &grepprg='git grep -f "' . expand('~/.vimsearch') . '"' " Read patterns from <file>, one per line.
set grepprg+=\ -I                 " Don't match the pattern in binary files.
set grepprg+=\ -n                 " Prefix the line number to matching lines.

set sessionoptions-=options       " Forget all options and mappings
set sessionoptions-=blank         " Forget empty windows (e.g. NERDTree, quickfix, etc.)
set sessionoptions+=resize        " Remember the size of the whole Vim window

set splitbelow                    " Splitting a window will put the new window below the current one.
set splitright                    " Splitting a window will put the new window right of the current one.

set foldlevelstart=99             " Sets 'foldlevel' when starting to edit another buffer in a window.
set foldminlines=1                " A fold can only be closed if it takes up two or more screen lines (this is the default).
set foldcolumn=0                  " Do not show a column at the side of the window to indicate open and closed folds.
set foldmethod=indent             " Lines with equal indent form a fold.
set foldtext=                     " Show only the most basic text to represent a fold.

set termguicolors                 " Enable true color in the terminal.

" Fix terminal cursor shapes:
let &t_SI.="\e[5 q"               " SI = INSERT mode
let &t_SR.="\e[4 q"               " SR = REPLACE mode
let &t_EI.="\e[1 q"               " EI = NORMAL mode (ELSE)

if has('mac')
  " Make :terminal source .bash_profile on macOS
  set shell=/bin/bash\ --rcfile\ ~/.bash_profile
endif

set smoothscroll                  " Make scrolling work when wrap is set
set autoread                      " Automatically read a file if it's changed outside of Vim

augroup ConfigureCursorline       " Make it so that only active window has cursorline
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter * if &buftype !=# 'terminal' | setlocal cursorline | endif
  autocmd WinLeave * setlocal nocursorline
augroup END

function! s:TerminalStatuslinePrefix(active) abort
  if a:active
    return "%#TerminalStatuslineRunning#%{term_getstatus('') ==# 'running' ? '-- TERMINAL --' : ''}%*"
  endif
  return "%{term_getstatus('') ==# 'running' ? '-- TERMINAL --' : ''}"
endfunction

function! s:SetTerminalStatusline(active) abort
  let l:tail = get(w:, 'terminal_statusline_tail', &g:statusline)
  let l:stl  = s:TerminalStatuslinePrefix(a:active) . l:tail
  execute "setlocal statusline=" . escape(l:stl, ' ')
  redrawstatus
endfunction

function! ConfigureTerminal() abort
  " Set terminal width equal to window width:
  execute "setlocal termwinsize=0x" . winwidth(0)

  " Do not show line numbers in terminal buffers:
  setlocal nonumber norelativenumber

  " Reduce jank
  setlocal nocursorline nocursorcolumn
  setlocal lazyredraw
  setlocal syntax=OFF

  " Add "insert mode" indicator for terminal buffers, highlighted only when active:
  let w:terminal_statusline_tail = &g:statusline
  call s:SetTerminalStatusline(1)
endfunction

augroup ConfigureTerminal
  autocmd!
  autocmd TerminalOpen * call ConfigureTerminal()
augroup END

augroup TerminalStatuslineFocus
  autocmd!
  autocmd WinEnter * if &buftype ==# 'terminal' | call <SID>SetTerminalStatusline(1) | endif
  autocmd WinLeave * if &buftype ==# 'terminal' | call <SID>SetTerminalStatusline(0) | endif
  " Handle showing an existing terminal buffer in a new window
  autocmd BufWinEnter * if &buftype ==# 'terminal' | call <SID>SetTerminalStatusline(1) | endif
augroup END

" Auto-reload buffers changed by an external process:
function! s:AutoReloadBuffer() abort
  if &buftype ==# '' && filereadable(expand('%:p'))
    checktime
  endif
endfunction

augroup AutoReloadBuffer
  autocmd!
  autocmd BufEnter * call s:AutoReloadBuffer()
augroup END

" Copy current buffer paths to the system clipboard.
function! s:GetCopyPath(kind) abort
  let l:file = expand('%:p')
  if empty(l:file)
    echoerr 'No file path available for this buffer'
    return ''
  endif

  if a:kind ==# 'absolute'
    return l:file
  endif

  " Default to a path relative to the working directory.
  return fnamemodify(l:file, ':.')
endfunction

function! s:CopyFilePath(kind, start_line, end_line) abort
  let l:path = s:GetCopyPath(a:kind)
  if empty(l:path)
    return
  endif

  let l:start = a:start_line
  let l:end = a:end_line

  if l:start > 0
    let l:end = l:end > 0 ? l:end : l:start
    if l:start > l:end
      let [l:start, l:end] = [l:end, l:start]
    endif
    if l:start == l:end
      let l:path .= ':' . l:start
    else
      let l:path .= ':' . l:start . '-' . l:end
    endif
  endif

  call setreg('+', l:path, 'v')
  call setreg('+', l:path, 'v')
  echo 'Copied: ' . l:path
endfunction

" Space is my Leader:
let mapleader = "\<Space>"

let g:ai_term_width = 100
let g:ai_term_send_delay_ms = 1000
command! -range -nargs=* Aider  call ai_term#OpenTerminalSession('aider',        <line1>, <line2>, <range>, <q-args>)
command! -range -nargs=* Claude call ai_term#OpenTerminalSession('claude',       <line1>, <line2>, <range>, <q-args>)
command! -range -nargs=* Codex  call ai_term#OpenTerminalSession('codex',        <line1>, <line2>, <range>, <q-args>)
command! -range -nargs=* Cursor call ai_term#OpenTerminalSession('cursor-agent', <line1>, <line2>, <range>, <q-args>)

function! s:JumpToAiTerm(cmd) abort
  let l:pos = getpos("'I")

  if l:pos[0] == 0 || !bufexists(l:pos[0])
    echohl ErrorMsg
    echo 'E20: Mark not set'
    echohl NONE
    return
  endif

  if !empty(a:cmd)
    execute a:cmd
  endif

  normal! 'I
  execute "normal \<C-w>e"
endfunction

function! s:JumpToAiTermWithSelection(cmd) abort
  call ai_term#RecordRange(bufnr('%'), line("'<"), line("'>"), 1)
  call s:JumpToAiTerm(a:cmd)
endfunction

nmap <silent> <Leader>i. :call <SID>JumpToAiTerm('')<CR>
nmap <silent> <Leader>il :call <SID>JumpToAiTerm('wincmd v')<CR>
nmap <silent> <Leader>iL :call <SID>JumpToAiTerm('botright wincmd v')<CR>
nmap <silent> <Leader>ih :call <SID>JumpToAiTerm('wincmd v\|wincmd h')<CR>
nmap <silent> <Leader>iH :call <SID>JumpToAiTerm('topleft wincmd v')<CR>
vnoremap <silent> <Leader>i. :<C-u>call <SID>JumpToAiTermWithSelection('')<CR>
vnoremap <silent> <Leader>il :<C-u>call <SID>JumpToAiTermWithSelection('wincmd v')<CR>
vnoremap <silent> <Leader>iL :<C-u>call <SID>JumpToAiTermWithSelection('botright wincmd v')<CR>
vnoremap <silent> <Leader>ih :<C-u>call <SID>JumpToAiTermWithSelection('wincmd v\|wincmd h')<CR>
vnoremap <silent> <Leader>iH :<C-u>call <SID>JumpToAiTermWithSelection('topleft wincmd v')<CR>

" Delete or wipe out any hidden buffers:
function! s:CloseHiddenBuffers(command, bang, verb) abort
  let l:hidden_buffers_all = filter(getbufinfo(), 'empty(v:val.windows)')

  if a:bang
    let l:hidden_buffers = l:hidden_buffers_all
  else
    let l:hidden_buffers = filter(copy(l:hidden_buffers_all), '!v:val.changed')
  endif

  if empty(l:hidden_buffers)
    echo 'No hidden buffers to ' . a:verb
    return
  endif

  let l:bufnrs = map(l:hidden_buffers, 'v:val.bufnr')

  execute a:command . (a:bang ? '!' : '') . ' ' . join(l:bufnrs)

  let l:count = len(l:hidden_buffers)
  let l:action = a:verb ==# 'wipeout' ? 'Wiped out' : 'Deleted'
  let l:skipped = a:bang ? 0 : (len(l:hidden_buffers_all) - l:count)
  let l:message = l:action . ' ' . l:count . ' hidden ' . (l:count == 1 ? 'buffer' : 'buffers')
  if l:skipped > 0
    let l:message .= ' (skipped ' . l:skipped . ' modified)'
  endif
  echo l:message
endfunction

command! -bang BwipeoutHidden call s:CloseHiddenBuffers('bwipeout', <bang>0, 'wipeout')
command! -bang BdeleteHidden call s:CloseHiddenBuffers('bdelete', <bang>0, 'delete')

" Go to file in a vertical split:
nmap <C-w>f :vertical wincmd f<CR>

" Make <C-w><BS> close current window like <C-w>c:
nnoremap <silent> <C-w><BS> <C-w>c
tnoremap <silent> <C-w><BS> <C-w>:close<CR>
nnoremap <silent> <C-w><C-BS> <C-w>c
tnoremap <silent> <C-w><C-BS> <C-w>:close<CR>

" Make new buffer in a vertical split:
nmap <silent> <C-w>n      :vertical new<CR>
tmap <silent> <C-w>n <C-w>:vertical new<CR>

" Make all windows equally wide with wincmd space:
nmap <silent> <C-w><Space>   :horizontal wincmd =<CR>
tmap <silent> <C-w><Space>   <C-w>:horizontal wincmd =<CR>

nmap <silent> <C-w><C-Space> :horizontal wincmd =<CR>
tmap <silent> <C-w><C-Space> <C-w>:horizontal wincmd =<CR>

" Make all windows equally tall with wincmd =:
nnoremap <silent> <C-w>=     :vertical wincmd =<CR>
tnoremap <silent> <C-w>=     <C-w>:vertical wincmd =<CR>

nnoremap <silent> <C-w><C-=> :vertical wincmd =<CR>
tnoremap <silent> <C-w><C-=> <C-w>:vertical wincmd =<CR>

" Fix Shift+Space bug in terminal mode:
tmap <S-Space> <Space>

" Fix <C-w><C-w> delay in terminal mode:
tmap <C-w><C-w> <C-w>w

" Set terminal width equal to window width when moved to the very top/bottom:
tmap <silent> <C-w>K <C-w>K<C-w>:execute "setlocal termwinsize=0x" . winwidth(0)<CR>
tmap <silent> <C-w>J <C-w>J<C-w>:execute "setlocal termwinsize=0x" . winwidth(0)<CR>

" A more ergonomic mapping for returning to a previous position in the jump list:
nmap gr <C-o>

" Neuter ZZ because it's too dangerous:
nnoremap ZZ zz

nnoremap <silent> <Leader>fa :call <SID>CopyFilePath('absolute', 0, 0)<CR>
nnoremap <silent> <Leader>fr :call <SID>CopyFilePath('relative', 0, 0)<CR>
nnoremap <silent> <Leader>fl :call <SID>CopyFilePath('relative', line('.'), line('.'))<CR>

vnoremap <silent> <Leader>fa :<C-u>call <SID>CopyFilePath('absolute', line("'<"), line("'>"))<CR>
vnoremap <silent> <Leader>fr :<C-u>call <SID>CopyFilePath('relative', line("'<"), line("'>"))<CR>
vnoremap <silent> <Leader>fl :<C-u>call <SID>CopyFilePath('relative', line("'<"), line("'>"))<CR>

" Expand %% on the command line to current file's directory path:
cnoremap %% <C-r>=expand('%:p:h')<CR>

" Indent current selection using Tab, de-indent using Shift-Tab:
vnoremap <silent> <Tab> VVgv>gv
vnoremap <silent> <S-Tab> VVgv<gv

" Shortcut to create a new tab:
nmap <silent> <C-w>a          :tabnew<CR>
tmap <silent> <C-w>a     <C-w>:tabnew<CR>

nmap <silent> <C-w><C-a>      :tabnew<CR>
tmap <silent> <C-w><C-a> <C-w>:tabnew<CR>

nmap <silent> <C-w>A          :-1tabnew<CR>

nmap <silent> <C-w>m          :wincmd v<Bar>wincmd T<Bar>silent! tabmove -1<CR>
tmap <silent> <C-w>m     <C-w>:wincmd v<Bar>wincmd T<Bar>silent! tabmove -1<CR>

nmap <silent> <C-w><C-m>      :wincmd v<Bar>wincmd T<Bar>silent! tabmove -1<CR>
tmap <silent> <C-w><C-m> <C-w>:wincmd v<Bar>wincmd T<Bar>silent! tabmove -1<CR>

nmap <silent> <C-w>M          :wincmd v<Bar>wincmd T<CR>

" Coverflow(tm)-style navigation for splits:
nmap <silent> <C-w>\          :set winminwidth=20<Bar>horizontal wincmd =<Bar>wincmd \|<Bar>set winminwidth=1<CR>
tmap <silent> <C-w>\     <C-w>:set winminwidth=20<Bar>horizontal wincmd =<Bar>wincmd \|<Bar>set winminwidth=1<CR>
xmap <silent> <C-w>\          :<C-U>set winminwidth=20<Bar>horizontal wincmd =<Bar>wincmd \|<Bar>set winminwidth=1<CR>

nmap <silent> <C-w><C-\>      :set winminwidth=20<Bar>horizontal wincmd =<Bar>wincmd \|<Bar>set winminwidth=1<CR>
tmap <silent> <C-w><C-\> <C-w>:set winminwidth=20<Bar>horizontal wincmd =<Bar>wincmd \|<Bar>set winminwidth=1<CR>
xmap <silent> <C-w><C-\>      :<C-U>set winminwidth=20<Bar>horizontal wincmd =<Bar>wincmd \|<Bar>set winminwidth=1<CR>

nmap <silent> <C-w>]          :set winminwidth=20<Bar>wincmd l<Bar>wincmd \|<Bar>set winminwidth=1<CR>
tmap <silent> <C-w>]     <C-w>:set winminwidth=20<Bar>wincmd l<Bar>wincmd \|<Bar>set winminwidth=1<CR>
xmap <silent> <C-w>]          :<C-U>set winminwidth=20<Bar>wincmd l<Bar>wincmd \|<Bar>set winminwidth=1<CR>

nmap <silent> <C-w><C-]>      :set winminwidth=20<Bar>wincmd l<Bar>wincmd \|<Bar>set winminwidth=1<CR>
tmap <silent> <C-w><C-]> <C-w>:set winminwidth=20<Bar>wincmd l<Bar>wincmd \|<Bar>set winminwidth=1<CR>
xmap <silent> <C-w><C-]>      :<C-U>set winminwidth=20<Bar>wincmd l<Bar>wincmd \|<Bar>set winminwidth=1<CR>

nmap <silent> <C-w>[          :set winminwidth=20<Bar>wincmd h<Bar>wincmd \|<Bar>set winminwidth=1<CR>
tmap <silent> <C-w>[     <C-w>:set winminwidth=20<Bar>wincmd h<Bar>wincmd \|<Bar>set winminwidth=1<CR>
xmap <silent> <C-w>[          :<C-U>set winminwidth=20<Bar>wincmd h<Bar>wincmd \|<Bar>set winminwidth=1<CR>

" Avoid accidental trigger on MacVim where <Esc> (<C-[>) after <C-w> is interpreted as part of this mapping:
if !has('mac')
  nmap <silent> <C-w><C-[>      :set winminwidth=20<Bar>wincmd h<Bar>wincmd \|<Bar>set winminwidth=1<CR>
  tmap <silent> <C-w><C-[> <C-w>:set winminwidth=20<Bar>wincmd h<Bar>wincmd \|<Bar>set winminwidth=1<CR>
  xmap <silent> <C-w><C-[>      :<C-U>set winminwidth=20<Bar>wincmd h<Bar>wincmd \|<Bar>set winminwidth=1<CR>
endif

" Resize window to fit content width:
nmap <silent> <C-w>e          :exe "vertical resize " . min([get(term_getsize(''), 1, 99999), max([&winwidth, max(map(getline(1,'$'), 'len(v:val)')) + (&number ? max([len(line('$')) + 1, &numberwidth]) : 0)])])<CR>
tmap <silent> <C-w>e     <C-w>:exe "vertical resize " . min([get(term_getsize(''), 1, 99999), max([&winwidth, max(map(getline(1,'$'), 'len(v:val)')) + (&number ? max([len(line('$')) + 1, &numberwidth]) : 0)])])<CR>

nmap <silent> <C-w><C-e>      :exe "vertical resize " . min([get(term_getsize(''), 1, 99999), max([&winwidth, max(map(getline(1,'$'), 'len(v:val)')) + (&number ? max([len(line('$')) + 1, &numberwidth]) : 0)])])<CR>
tmap <silent> <C-w><C-e> <C-w>:exe "vertical resize " . min([get(term_getsize(''), 1, 99999), max([&winwidth, max(map(getline(1,'$'), 'len(v:val)')) + (&number ? max([len(line('$')) + 1, &numberwidth]) : 0)])])<CR>

" Quickfix window mappings:
nmap <silent> <Leader>co :botright copen<CR>
nmap <silent> <Leader>cq :cclose<CR>
nmap <silent> <Leader>cc :cc<CR>
nmap <silent> <Leader>ct :Qfilter!\V\<tests\?\>\C<CR>
nmap <silent> <Leader>cT :Qfilter\V\<tests\?\>\C<CR>

" Tab navigation mappings:
nmap <silent> [t :tabprevious<CR>
xmap <silent> [t :<C-U>tabprevious<CR>

nmap <silent> [T :tabfirst<CR>
xmap <silent> [T :<C-U>tabfirst<CR>

xmap <silent> ]t :<C-U>tabnext<CR>
nmap <silent> ]t :tabnext<CR>

nmap <silent> ]T :tablast<CR>
xmap <silent> ]T :<C-U>tablast<CR>

" Cut/Copy/Paste using the system clipboard:
vnoremap <C-x> "+x
vnoremap <C-c> "+y
vnoremap <C-v> "+p
nnoremap <C-v> "+p
inoremap <C-v> <C-r>+
cnoremap <C-v> <C-r>+
tnoremap <C-v> <C-w>"+

if has('mac')
  vnoremap <D-x> "+x
  vnoremap <D-c> "+y
  vnoremap <D-v> "+p
  nnoremap <D-v> "+p
  inoremap <D-v> <C-r>+
  cnoremap <D-v> <C-r>+
  tnoremap <D-v> <C-w>"+
endif

" Double-tap to put a semi-colon or comma at the end of line:
inoremap ;; <C-g>u<Esc>:call setline('.', getline('.') . ';')<CR>gi<C-g>u
inoremap ,, <C-g>u<Esc>:call setline('.', getline('.') . ',')<CR>gi<C-g>u

" Set current word or selection to be the current search term:
nnoremap <silent> gn :call SetSearchTermNormal()<CR>
vnoremap <silent> gn :<C-u>call SetSearchTermVisual()<CR>

" Toggle highlighting of all occurrences of the current search term:
nnoremap <silent> gh :set hls!<CR>

" Map F5 to write the buffer:
nmap <silent> <F5> :write<CR>
imap <silent> <F5> <Esc><F5>

" Map jj to Esc
imap jj <Esc>
tmap jj <C-w>N

" Trigger normal mode on scroll in terminal
function! s:term_scroll(dir) abort
  let l:pos = getmousepos()
  let l:wheel = a:dir ==# 'up' ? "\<ScrollWheelUp>" : "\<ScrollWheelDown>"
  if l:pos.winid == win_getid()
    return "\<C-w>N" . l:wheel
  endif
  return l:wheel
endfunction

tnoremap <expr> <ScrollWheelUp>   <SID>term_scroll('up')
tnoremap <expr> <ScrollWheelDown> <SID>term_scroll('down')

" Trigger normal mode on left click in terminal
function! s:term_click() abort
  let l:pos = getmousepos()
  if l:pos.winid == win_getid()
    return "\<C-w>N\<LeftMouse>"
  endif
  return "\<LeftMouse>"
endfunction

tnoremap <expr> <LeftMouse> <SID>term_click()

" Map <Leader>l to:
" 1. clear and redraw the screen
" 2. reload the file if necessary
" 3. fix broken syntax highlighting
" 4. get rid of stale lint errors
nnoremap <silent> <Leader>l <C-l>:checktime<CR>:syntax sync fromstart<CR>:ALELint<CR>

" Close a window via Stargate:
noremap  <C-w>, <Cmd>call <SID>CloseStargateWindow()<CR>
tnoremap <C-w>, <Cmd>call <SID>CloseStargateWindow()<CR>

cnoremap <expr> <C-p> wildmenumode() ? '<C-p>' : '<Up>'
cnoremap <expr> <C-n> wildmenumode() ? '<C-n>' : '<Down>'

" Replace :bm with :ls+ because there's no way to make :bm ignore Terminal buffers:
cabbrev bm <c-r>=(getcmdtype() == ':' && getcmdpos() == 1 ? 'ls+' : 'bm')<CR>

" Find in files:
nnoremap <silent> <F3>   :call FindInFiles('')<CR>
nnoremap <silent> <S-F3> :call FindInFiles(SetSearchTermNormal(), 1)<CR>
vnoremap <silent> <F3>   :<C-u>call FindInFiles(SetSearchTermVisual())<CR>
vnoremap <silent> <S-F3> :<C-u>call FindInFiles(SetSearchTermVisual(), 1)<CR>

function! SetSearchTermNormal()
  let str = expand("<cword>")
  if strlen(str) == 0
    echohl ErrorMsg
    echo 'E348: No string under cursor'
    echohl NONE
  else
    let @/ = '\V\<' . str . '\>\C'
    exe "normal /" . @/ . "\<C-c>"
  endif
  return str
endfunction

function! SetSearchTermVisual()
  let reg = getreg('"')
  let regtype = getregtype('"')
  normal! gvy
  let str = @"
  call setreg('"', reg, regtype)
  let @/ = '\V' . substitute(escape(str, '\'), '\n', '\\n', 'g')
  exe "normal /" . @/ . "\<C-c>"
  return str
endfunction

function! FindInFiles(text, ...)
  let txt = a:text
  let cmd = ':botright copen | silent grep!'
  if get(a:, 1, 0)
    if strlen(txt) == 0
      return
    endif
    let txt = '\b' . txt . '\b'
    let cmd = cmd . ' -P'
  else
    let cmd = cmd . ' -Fi'
  endif
  let str = input('Search ' . getcwd() . '>', txt)
  if empty(str)
    redraw!
  else
    call writefile([str], expand('~/.vimsearch'))
    call feedkeys(cmd)
  endif
endfunction

function! s:CloseStargateWindow() abort
  let l:origin = win_getid()

  " Temporarily link labels to a close-mode group (red text, same bg)
  let l:labels_hl = hlget('StargateLabels')

  try
    execute 'highlight! link StargateLabels StargateErrorLabels'
    call stargate#Galaxy()
  finally
    if !empty(l:labels_hl)
      call hlset(l:labels_hl)
    else
      highlight clear StargateLabels
    endif
  endtry

  let l:target = win_getid()
  let [l:tabnr, l:winnr] = win_id2tabwin(l:target)

  if l:target == l:origin || l:tabnr == 0
    call win_gotoid(l:origin)
    return
  endif

  call win_gotoid(l:origin)
  call win_execute(l:target, 'close')
  call win_gotoid(l:origin)
endfunction

" vim-fugitive plugin settings:
augroup ConfigureFugitivePlugin
  autocmd!
  autocmd User FugitiveIndex setlocal bufhidden=hide
augroup END

function! s:WarnFugitiveBuffer() abort
  if get(b:, 'fugitive_type', '') ==# 'index'
    return
  endif
  if !exists('b:fugitive_warning_statusline')
    let b:fugitive_warning_statusline = 1
    let &l:statusline = '%#ErrorMsg#[FUGITIVE]%*' . &g:statusline
    setlocal nomodifiable
  endif
endfunction

augroup FugitiveWarningStatusline
  autocmd!
  autocmd BufWinEnter fugitive://* call <SID>WarnFugitiveBuffer()
augroup END

function! s:GitStatusInNewTab()
  -tabnew
  let l:newbuf = bufnr('%')
  Ge:
  if bufnr('%') != l:newbuf
    silent! execute 'bwipeout ' . l:newbuf
  endif
endfunction

nmap <silent> <Leader>gb      :Git blame<CR>
nmap <silent> <Leader>gv      :GV -99<CR>
nmap <silent> <Leader>ge      :Gedit<CR>

nmap <silent> <Leader>gg      :call <SID>GitStatusInNewTab()<CR>
nmap <silent>    <C-w>gg      :call <SID>GitStatusInNewTab()<CR>
tmap <silent>    <C-w>gg <C-w>:call <SID>GitStatusInNewTab()<CR>

nmap <silent> <Leader>gh      :wincmd v<Bar>wincmd h<Bar>Ge:<CR>
nmap <silent>    <C-w>gh      :wincmd v<Bar>wincmd h<Bar>Ge:<CR>
tmap <silent>    <C-w>gh <C-w>:wincmd v<Bar>wincmd h<Bar>Ge:<CR>

nmap <silent> <Leader>gH      :topleft wincmd v<Bar>Ge:<CR>
nmap <silent>    <C-w>gH      :topleft wincmd v<Bar>Ge:<CR>
tmap <silent>    <C-w>gH <C-w>:topleft wincmd v<Bar>Ge:<CR>

nmap <silent> <Leader>gj      :wincmd s<Bar>Ge:<CR>
nmap <silent>    <C-w>gj      :wincmd s<Bar>Ge:<CR>
tmap <silent>    <C-w>gj <C-w>:wincmd s<Bar>Ge:<CR>

nmap <silent> <Leader>gJ      :botright wincmd s<Bar>Ge:<CR>
nmap <silent>    <C-w>gJ      :botright wincmd s<Bar>Ge:<CR>
tmap <silent>    <C-w>gJ <C-w>:botright wincmd s<Bar>Ge:<CR>

nmap <silent> <Leader>gk      :wincmd s<Bar>wincmd k<Bar>Ge:<CR>
nmap <silent>    <C-w>gk      :wincmd s<Bar>wincmd k<Bar>Ge:<CR>
tmap <silent>    <C-w>gk <C-w>:wincmd s<Bar>wincmd k<Bar>Ge:<CR>

nmap <silent> <Leader>gK      :topleft wincmd s<Bar>Ge:<CR>
nmap <silent>    <C-w>gK      :topleft wincmd s<Bar>Ge:<CR>
tmap <silent>    <C-w>gK <C-w>:topleft wincmd s<Bar>Ge:<CR>

nmap <silent> <Leader>gl      :wincmd v<Bar>Ge:<CR>
nmap <silent>    <C-w>gl      :wincmd v<Bar>Ge:<CR>
tmap <silent>    <C-w>gl <C-w>:wincmd v<Bar>Ge:<CR>

nmap <silent> <Leader>gL      :botright wincmd v<Bar>Ge:<CR>
nmap <silent>    <C-w>gL      :botright wincmd v<Bar>Ge:<CR>
tmap <silent>    <C-w>gL <C-w>:botright wincmd v<Bar>Ge:<CR>

nmap <silent> <Leader>g.      :Ge:<CR>
nmap <silent>    <C-w>g.      :Ge:<CR>
tmap <silent>    <C-w>g. <C-w>:Ge:<CR>

" vim-gitgutter plugin settings:
set updatetime=100
nmap <Leader>gp <Plug>(GitGutterPreviewHunk)
nmap <Leader>gs <Plug>(GitGutterStageHunk)
nmap <Leader>gu <Plug>(GitGutterUndoHunk)
nmap <silent> <Leader>gc :GitGutterQuickFix<Bar>botright copen<CR>
nmap <silent> <Leader>gi :GitGutterLineHighlightsToggle<CR>
nmap <silent> <Leader>gt :GitGutterToggle<CR>
nmap <silent> <Leader>gz :GitGutterFold<CR>

" ctrlp.vim plugin settings:
let g:ctrlp_user_command = ['.git', 'git ls-files -co --exclude-standard']
let g:ctrlp_working_path_mode = 0
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_max_height = 999
let g:ctrlp_bufname_mod = ':.'
let g:ctrlp_bufpath_mod = ''
let g:ctrlp_match_current_file = 1
let g:ctrlp_switch_buffer = 'e'
nnoremap <silent> <C-@> :CtrlPBuffer<CR>
vnoremap <silent> <C-@> :<C-U>CtrlPBuffer<CR>
nmap <C-Space> <C-@>
vmap <C-Space> <C-@>
let g:ctrlp_prompt_mappings = {'PrtExit()': ['<C-@>', '<C-Space>', '<Esc>', '<C-c>', '<C-g>']}
let g:ctrlp_map = '<Leader>p'

" auto-pairs plugin settings:
let g:AutoPairsCenterLine = 0
let g:AutoPairsFlyMode = 0
let g:AutoPairShortcutToggle = ''
let g:AutoPairsShortcutFastWrap = ''
let g:AutoPairsShortcutJump = ''
let g:AutoPairsShortcutBackInsert = ''

" nerdtree plugin settings:
let NERDTreeQuitOnOpen=1
let NERDTreeMinimalMenu=1
let NERDTreeMinimalUI = 1
let NERDTreeHighlightCursorline = 1
let NERDTreeShowHidden = 1
let NERDTreeHijackNetrw = 0
let NERDTreeNodeDelimiter="\u00b7" " (middle dot)
let NERDTreeCustomOpenArgs = { 'file': { 'reuse': 'currenttab', 'where': 'p' }, 'dir': {} }
nmap <silent> <Leader>fo :NERDTreeFocus<CR>
nmap <silent> <Leader>fq :NERDTreeClose<CR>
nmap <silent> <Leader>ff :NERDTreeFind<CR>

" emmet-vim plugin settings:
let g:emmet_install_only_plug = 1
imap <C-\> <plug>(emmet-expand-abbr)
vmap <C-\> <plug>(emmet-expand-abbr)

" Disable the built-in Zip plugin
let g:loaded_zipPlugin = 1
let g:loaded_zip = 1

" vim-ruby plugin settings:
let g:ruby_indent_block_style = 'do'

" ALE plugin settings:
function! ALEHoverPopupFilter(winid, key) abort
  if a:key ==# "\<Esc>" || a:key ==# "\<C-[>"
    call popup_close(a:winid)
    return 1
  endif

  return 0
endfunction

function! ALEFloatingPreviewPopupOpts() abort
  return {
        \ 'highlight': 'Normal',
        \ 'borderhighlight': ['Normal'],
        \ 'filter': 'ALEHoverPopupFilter',
        \ 'close': 'click',
        \ 'mapping': v:true,
        \ }
endfunction

let g:ale_fix_on_save = 1
let g:ale_fixers = {
      \   'javascript': ['eslint'],
      \   'typescript': ['prettier'],
      \   'typescriptreact': ['prettier'],
      \   'html': ['prettier'],
      \   'css': ['prettier'],
      \ }

let g:ale_lint_on_save = 1
let g:ale_linters_explicit = 1
let g:ale_linters = {
      \   'javascript': ['eslint', 'tsserver'],
      \   'typescript': ['eslint', 'tsserver'],
      \   'typescriptreact': ['eslint', 'tsserver'],
      \   'ruby': ['ruby'],
      \ }

let g:ale_javascript_eslint_options="--rule 'no-debugger: off, import/no-unused-modules: off'"

let g:ale_lint_on_enter = 0
let g:ale_lint_on_filetype_changed = 0
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_text_changed = 0

let g:ale_set_highlights = 0
let g:ale_set_balloons = 0
let g:ale_hover_cursor = 0
let g:ale_hover_to_floating_preview = 1
let g:ale_floating_window_border = ['│', '─', '╭', '╮', '╯', '╰', '│', '─']
let g:ale_floating_preview_popup_opts = 'ALEFloatingPreviewPopupOpts'

nmap K :ALEHover<CR>
nmap <F1> :ALEDocumentation<CR>

nmap gd         :ALEGoToDefinition<CR>
nmap <C-w>d     :ALEGoToDefinition -vsplit<CR>
nmap <C-w>D     :ALEGoToDefinition -split<CR>
nmap <C-w><C-d> :ALEGoToDefinition -split<CR>
nmap <C-w>gd    :ALEGoToDefinition -tab<CR>

nmap [E :ALEFirst<CR>
nmap [e :ALEPrevious<CR>
nmap ]e :ALENext<CR>
nmap ]E :ALELast<CR>

imap <expr> <C-@> ((pumvisible())?("\<C-n>"):("\<Plug>(ale_complete)"))
imap <expr> <C-Space> ((pumvisible())?("\<C-n>"):("\<Plug>(ale_complete)"))
inoremap <expr> <C-j> ((pumvisible())?("\<C-n>"):("\<C-j>"))
inoremap <expr> <C-k> ((pumvisible())?("\<C-p>"):("\<C-k>"))

function! ALEProgress() abort
  if exists('*ale#engine#IsCheckingBuffer') && ale#engine#IsCheckingBuffer(bufnr(''))
    return '[lint...]'
  endif

  return ''
endfunction

function! ALEStatus() abort
  if exists('*ale#engine#IsCheckingBuffer') && ale#engine#IsCheckingBuffer(bufnr(''))
    return ''
  endif

  let l:issues = ale#statusline#Count(bufnr('')).total

  if l:issues == 0
    return ''
  endif

  if l:issues == 1
    return '[1 issue]'
  endif

  return printf('[%d issues]', l:issues)
endfunction

set statusline+=%#WarningMsg#%{ALEProgress()}%*
set statusline+=%#ErrorMsg#%{ALEStatus()}%*

augroup ConfigureAlePlugin
  autocmd!
  autocmd User ALEJobStarted redrawstatus!
  autocmd User ALELintPost redrawstatus!
augroup END

" targets.vim plugin settings:
if !exists('g:targets_nl')
  let g:targets_nl = 'nN'
endif

augroup ConfigureTargetsPlugin
  autocmd!
  autocmd User targets#mappings#user call targets#mappings#extend({
        \   'a': {'argument': [{'o': '[{([]', 'c': '[])}]', 's': ','}]},
        \   'b': {'pair': [{'o':'(', 'c':')'}]},
        \ })
augroup END

" vim-textobj-entire plugin settings:
let g:textobj_entire_no_default_key_mappings = 1
xmap ag <Plug>(textobj-entire-a)
omap ag <Plug>(textobj-entire-a)
xmap ig <Plug>(textobj-entire-i)
omap ig <Plug>(textobj-entire-i)

" Replace vim-wheel plugin:
function! s:scroll_move(direction) abort
  let l:scroll = a:direction ==# 'down' ? "\<C-e>" : "\<C-y>"

  if a:direction ==# 'down'
    if winline() == 1
      return l:scroll
    endif
  else
    if winline() == winheight(0)
      return l:scroll
    endif
  endif

  if &wrap
    return l:scroll . (a:direction ==# 'down' ? 'gj' : 'gk')
  endif

  return l:scroll . (a:direction ==# 'down' ? 'j' : 'k')
endfunction

noremap <C-h> zh
noremap <C-l> zl
noremap <expr> <C-j> <SID>scroll_move('down')
noremap <expr> <C-k> <SID>scroll_move('up')

" QFEnter plugin settings:
let g:qfenter_keymap = {}
let g:qfenter_keymap.open = ['<CR>', '<2-LeftMouse>']
let g:qfenter_keymap.vopen = ['<C-w><CR>']
let g:qfenter_keymap.topen = ['<C-w><Tab>']

" projectionist plugin settings:
nmap <silent> <Leader>a :A<CR>
nmap <silent> <Leader>A :AV<CR>

" vim-dadbod-ui plugin settings:
let g:db_ui_show_help = 0
let g:db_ui_auto_execute_table_helpers = 1
let g:db_ui_force_echo_notifications = 1
let g:db_ui_drawer_sections = ['new_query', 'schemas', 'saved_queries', 'buffers']

" disable vim-dadbod-completion:
let g:vim_dadbod_completion_loaded = 1

call tcomment#type#Define('mysql', '-- %s')
call tcomment#type#Define('plsql', '-- %s')

nmap <silent> <Leader>do :DBUI<CR>
nmap <silent> <Leader>dq :DBUIClose<CR>
nmap <silent> <Leader>df :DBUIFindBuffer<CR>

let g:db_ui_table_helpers = {
      \ 	'mysql': {
      \ 		'Show Create Table': 'SHOW CREATE TABLE {optional_schema}`{table}`',
      \ 	}
      \ }

" vim9-stargate plugin settings:
noremap <Leader>j <Cmd>call stargate#OKvim(1)<CR>
noremap <C-w>; <Cmd>call stargate#Galaxy()<CR>
tnoremap <C-w>; <Cmd>call stargate#Galaxy()<CR>

" vim-closetag plugin settings:
let g:closetag_filetypes = 'html,xml,javascript'
let g:closetag_regions = {
      \ 'javascript': 'litHtmlRegion',
      \ }

" vim-markdown plugin settings:
let g:vim_markdown_folding_disabled = 1
let g:markdown_folding = 1 " use native vim folding for markdown
let g:vim_markdown_toc_autofit = 1
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0
let g:vim_markdown_fenced_languages = ['js=javascript']

" colorscheme settings:
function! OverrideColorscheme() abort
  if &background ==# 'dark'
    highlight Search guifg=#1c1c1c guibg=#98971a gui=NONE ctermfg=234 ctermbg=100 cterm=NONE
  else
    highlight Search guifg=#fbf1c7 guibg=#98971a gui=NONE ctermfg=230 ctermbg=100 cterm=NONE
  endif

  highlight TerminalStatuslineRunning guifg=#1d2021 guibg=#fabd2f gui=bold ctermfg=234 ctermbg=214 cterm=bold

  highlight! link IncSearch Search
  highlight! link CurSearch Search

  " Tweak git-oriented highlights so Fugitive, GV, and GitGutter still match
  " the colorscheme palette while using foreground-only accents where desired.

  " Keep colorscheme backgrounds for full-line gitgutter highlights.
  highlight! link GitGutterAddLine            DiffAdd
  highlight! link GitGutterAddLineNr          DiffAdd
  highlight! link GitGutterAddIntraLine       DiffAdd
  highlight! link GitGutterChangeLine         DiffChange
  highlight! link GitGutterChangeLineNr       DiffChange
  highlight! link GitGutterChangeDeleteLine   DiffChange
  highlight! link GitGutterChangeDeleteLineNr DiffChange
  highlight! link GitGutterDeleteLine         DiffDelete
  highlight! link GitGutterDeleteLineNr       DiffDelete
  highlight! link GitGutterDeleteIntraLine    DiffDelete

  " Foreground-only accents for status views (Fugitive, GV) and sign columns.
  function! s:HiFgFrom(group, target) abort
    let l:fg = synIDattr(hlID(a:group), 'fg#')
    let l:ctermfg = synIDattr(hlID(a:group), 'fg', 'cterm')
    if l:fg != ''
      execute 'highlight! ' . a:target . ' guifg=' . l:fg . ' guibg=NONE gui=NONE'
    endif
    if l:ctermfg != ''
      execute 'highlight! ' . a:target . ' ctermfg=' . l:ctermfg . ' ctermbg=NONE cterm=NONE'
    endif
  endfunction

  " Clear Diff* so they don't inherit stale values on colorscheme switch.
  highlight clear DiffAdd
  highlight clear DiffChange
  highlight clear DiffDelete

  call s:HiFgFrom('DiffAdd', 'Added')
  call s:HiFgFrom('DiffChange', 'Changed')
  call s:HiFgFrom('DiffDelete', 'Removed')

  highlight! link diffAdded             Added
  highlight! link gitDiffAdded          Added
  highlight! link GitGutterAdd          Added
  highlight! link diffChanged           Changed
  highlight! link gitDiffChanged        Changed
  highlight! link GitGutterChange       Changed
  highlight! link GitGutterChangeDelete Changed
  highlight! link diffRemoved           Removed
  highlight! link gitDiffRemoved        Removed
  highlight! link GitGutterDelete       Removed

  " Re-apply ALE highlights
  highlight link ALEErrorSign error
  highlight link ALEStyleErrorSign ALEErrorSign
  highlight link ALEWarningSign todo
  highlight link ALEStyleWarningSign ALEWarningSign
  highlight link ALEInfoSign ALEWarningSign
  highlight link ALESignColumnWithErrors error
  highlight link ALEVirtualTextError Comment
  highlight link ALEVirtualTextStyleError ALEVirtualTextError
  highlight link ALEVirtualTextWarning Comment
  highlight link ALEVirtualTextStyleWarning ALEVirtualTextWarning
  highlight link ALEVirtualTextInfo ALEVirtualTextWarning

  " Stargate labels: normal uses theme bg; close-mode gruvbox red fg only
  highlight! StargateLabels      guifg=#caa247 guibg=bg ctermbg=bg
  highlight! StargateErrorLabels guifg=#fb4934 guibg=bg ctermfg=167 ctermbg=bg
  highlight! StargateMain        guibg=bg ctermbg=bg
  highlight! StargateSecondary   guibg=bg ctermbg=bg
endfunction

function! OverrideColorschemeRetrobox() abort
  highlight link GitCommitSummary Title

  if &background ==# 'dark'
    highlight Visual guifg=#83a598 guibg=#1c1c1c gui=reverse ctermfg=109 ctermbg=234 cterm=reverse
    highlight QuickFixLine guifg=#1c1c1c guibg=#8ec07c gui=NONE ctermfg=234 ctermbg=107 cterm=NONE
    highlight CursorLine guibg=#262626 ctermbg=235
  else
    highlight Visual guifg=#076678 guibg=#fbf1c7 gui=reverse ctermfg=23 ctermbg=230 cterm=reverse
    highlight QuickFixLine guifg=#fbf1c7 guibg=#427b58 gui=NONE ctermfg=230 ctermbg=29 cterm=NONE
    highlight CursorLine guibg=#f2e5bc ctermbg=229
  endif
endfunction

augroup ConfigureColorscheme
  autocmd!
  autocmd ColorScheme * call OverrideColorscheme()
  autocmd ColorScheme retrobox call OverrideColorschemeRetrobox()
augroup END

set background=dark
colorscheme catppuccin
