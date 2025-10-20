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

" Fix terminal cursor shapes:
let &t_SI.="\e[5 q"               " SI = INSERT mode
let &t_SR.="\e[4 q"               " SR = REPLACE mode
let &t_EI.="\e[1 q"               " EI = NORMAL mode (ELSE)

if has('mac')
  " Make :terminal source .bash_profile on macOS
  set shell=/bin/bash\ --rcfile\ ~/.bash_profile
endif

set tags=./tags;                  " Look for tags files starting in directory of current file and up
set tagcase=match                 " Make tags file search case-sensitive

set smoothscroll                  " Make scrolling work when wrap is set
set autoread                      " Automatically read a file if it's changed outside of Vim

augroup ConfigureCursorline       " Make it so that only active window has cursorline
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter * if &buftype !=# 'terminal' | setlocal cursorline | endif
  autocmd WinLeave * setlocal nocursorline
augroup END

function! s:TerminalStatuslinePrefix(active) abort
  if a:active
    return "%#DiffText#%{term_getstatus('') ==# 'running' ? '-- TERMINAL --' : ''}%*"
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

let mapleader = "\<Space>"        " Space is my Leader

let g:terminal_width = get(g:, 'terminal_width', 100)
command! -nargs=* Aider  execute "vertical botright terminal ++cols=" . g:terminal_width . " aider        <args>" | set filetype=aider
command! -nargs=* Claude execute "vertical botright terminal ++cols=" . g:terminal_width . " claude       <args>" | set filetype=claude
command! -nargs=* Codex  execute "vertical botright terminal ++cols=" . g:terminal_width . " codex        <args>" | set filetype=codex
command! -nargs=* Cursor execute "vertical botright terminal ++cols=" . g:terminal_width . " cursor-agent <args>" | set filetype=cursor

" Jump to definition if there's only one matching tag, otherwise list all matching tags:
map  g]                       g<C-]>
map  <C-]>                    g<C-]>
nmap <C-LeftMouse> <LeftMouse>g<C-]>
vmap <C-LeftMouse>            g<C-]>
nmap g<LeftMouse>  <LeftMouse>g<C-]>
vmap g<LeftMouse>             g<C-]>
map  <C-w>]              <C-w>g<C-]>
map  <C-w><C-]>          <C-w>g<C-]>
map  <C-w>g]             <C-w>g<C-]>

" Go to file in a vertical split:
nmap <C-w>f :vertical wincmd f<CR>

" Make new buffer in a vertical split:
nmap <silent> <C-w>n      :vertical new<CR>
tmap <silent> <C-w>n <C-w>:vertical new<CR>

" Make all windows equally wide with wincmd space:
nmap <silent> <C-w><Space>   :horizontal wincmd =<CR>
tmap <silent> <C-w><Space>   <C-w>:horizontal wincmd =<CR>

nmap <silent> <C-w><C-Space> :horizontal wincmd =<CR>
tmap <silent> <C-w><C-Space> <C-w>:horizontal wincmd =<CR>

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

" Close NERDTree before expanding windows horizontally lest it be crippled:
nmap <silent> <C-w>\|         :NERDTreeClose<Bar>wincmd \|<CR>
tmap <silent> <C-w>\|    <C-w>:NERDTreeClose<Bar>wincmd \|<CR>

" Coverflow(tm)-style navigation for splits:
nmap <silent> <C-w>\          :set winminwidth=20<Bar>horizontal wincmd =<Bar>wincmd \|<Bar>set winminwidth=1<CR>
tmap <silent> <C-w>\     <C-w>:set winminwidth=20<Bar>horizontal wincmd =<Bar>wincmd \|<Bar>set winminwidth=1<CR>

nmap <silent> <C-w>]          :set winminwidth=20<Bar>wincmd l<Bar>wincmd \|<Bar>set winminwidth=1<CR>
tmap <silent> <C-w>]     <C-w>:set winminwidth=20<Bar>wincmd l<Bar>wincmd \|<Bar>set winminwidth=1<CR>

nmap <silent> <C-w>[          :set winminwidth=20<Bar>wincmd h<Bar>wincmd \|<Bar>set winminwidth=1<CR>
tmap <silent> <C-w>[     <C-w>:set winminwidth=20<Bar>wincmd h<Bar>wincmd \|<Bar>set winminwidth=1<CR>

" Resize window to fit content width:
nmap <silent> <C-w>e          :exe "vertical resize " . min([get(term_getsize(''), 1, 99999), max([&winwidth, max(map(getline(1,'$'), 'len(v:val)')) + (&number ? max([len(line('$')) + 1, &numberwidth]) : 0)])])<CR>
tmap <silent> <C-w>e     <C-w>:exe "vertical resize " . min([get(term_getsize(''), 1, 99999), max([&winwidth, max(map(getline(1,'$'), 'len(v:val)')) + (&number ? max([len(line('$')) + 1, &numberwidth]) : 0)])])<CR>

nmap <silent> <C-w><C-e>      :exe "vertical resize " . min([get(term_getsize(''), 1, 99999), max([&winwidth, max(map(getline(1,'$'), 'len(v:val)')) + (&number ? max([len(line('$')) + 1, &numberwidth]) : 0)])])<CR>
tmap <silent> <C-w><C-e> <C-w>:exe "vertical resize " . min([get(term_getsize(''), 1, 99999), max([&winwidth, max(map(getline(1,'$'), 'len(v:val)')) + (&number ? max([len(line('$')) + 1, &numberwidth]) : 0)])])<CR>

" Quickfix window mappings:
nmap <silent> <Leader>co :botright copen<CR>
nmap <silent> <Leader>cq :cclose<CR>
nmap <silent> <Leader>cc :cc<CR>
nmap <silent> <Leader>ct :Qfilter!\V\<test\>\C<CR>
nmap <silent> <Leader>cT :Qfilter\V\<test\>\C<CR>

" Tab navigation mappings:
nmap <silent> [t :tabprevious<CR>
nmap <silent> [T :tabfirst<CR>
nmap <silent> ]t :tabnext<CR>
nmap <silent> ]T :tablast<CR>

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
" 2. fix broken syntax highlighting
" 3. get rid of stale lint errors
nnoremap <silent> <Leader>l <C-l>:syntax sync fromstart<CR>:ALELint<CR>

" Close a window via Stargate:
noremap  <C-w>. <Cmd>call <SID>CloseStargateWindow()<CR>
tnoremap <C-w>. <Cmd>call <SID>CloseStargateWindow()<CR>

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
  call stargate#Galaxy()
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
nmap <silent> <Leader>gg :-tab Git<CR>
nmap <silent> <Leader>gb :Git blame<CR>
nmap <silent> <Leader>gv :GV -99<CR>

" vim-gitgutter plugin settings:
set updatetime=100
nmap <Leader>gp <Plug>(GitGutterPreviewHunk)
nmap <Leader>gs <Plug>(GitGutterStageHunk)
nmap <Leader>gu <Plug>(GitGutterUndoHunk)
nmap <silent> <Leader>gc :GitGutterQuickFix<Bar>botright copen<CR>
nmap <silent> <Leader>gh :GitGutterLineHighlightsToggle<CR>
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
nnoremap <silent> <C-@> :CtrlPBuffer<CR>
nmap <C-Space> <C-@>
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
let g:NERDTreeMinimalMenu=1
let NERDTreeMinimalUI = 1
let NERDTreeHighlightCursorline = 1
let NERDTreeShowHidden = 1
let NERDTreeHijackNetrw = 0
let NERDTreeNodeDelimiter="\u00b7" " (middle dot)
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
      \   'typescript': ['tsserver'],
      \   'typescriptreact': ['tsserver'],
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

nmap <Leader>h  :ALEHover<CR>

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

function! ALEStatus() abort
  let l:issues = ale#statusline#Count(bufnr('')).total

  if l:issues == 0
    return ''
  endif

  if l:issues == 1
    return '[1 issue]'
  endif

  return printf('[%d issues]', l:issues)
endfunction

set statusline+=%#error#%{ALEStatus()}%*

augroup ConfigureAlePlugin
  autocmd!
  autocmd User ALELintPost redrawstatus
augroup END

function! ReapplyALEHighlights() abort
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
endfunction

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

let g:qfenter_excluded_action = 'error'

let g:qfenter_exclude_filetypes = [
      \   'fugitiveblame',
      \   'fugitive',
      \   'nerdtree',
      \   'git',
      \   'GV',
      \ ]

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


" colorscheme settings:
function! OverrideColorscheme() abort
  if &background ==# 'dark'
    highlight Search guifg=#1c1c1c guibg=#98971a gui=NONE ctermfg=234 ctermbg=100 cterm=NONE
    highlight Visual guifg=#83a598 guibg=#1c1c1c gui=reverse ctermfg=109 ctermbg=234 cterm=reverse
    highlight QuickFixLine guifg=#1c1c1c guibg=#8ec07c gui=NONE ctermfg=234 ctermbg=107 cterm=NONE
  else
    highlight Search guifg=#fbf1c7 guibg=#98971a gui=NONE ctermfg=230 ctermbg=100 cterm=NONE
    highlight Visual guifg=#076678 guibg=#fbf1c7 gui=reverse ctermfg=23 ctermbg=230 cterm=reverse
    highlight QuickFixLine guifg=#fbf1c7 guibg=#427b58 gui=NONE ctermfg=230 ctermbg=29 cterm=NONE
  endif

  highlight link GitCommitSummary Title

  call ReapplyALEHighlights()
endfunction

augroup ConfigureColorscheme
  autocmd!
  autocmd ColorScheme retrobox call OverrideColorscheme()
augroup END

set background=dark
colorscheme retrobox
