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

set history=420                   " The number of commands and search patterns to keep in history.

set mouse=a                       " Enable the use of the mouse in all modes.

set noequalalways                 " Don't make all windows same size after splitting or closing a window.
set winminheight=1                " The minimal height of a window, when it's not the current window.
set winminwidth=1                 " The minimal width of a window, when it's not the current window.

let &grepprg='git grep -f "' . expand('~/.vimsearch') . '"' " Read patterns from <file>, one per line.
set grepprg+=\ -I                 " Don't match the pattern in binary files.
set grepprg+=\ -n                 " Prefix the line number to matching lines.
set grepprg+=\ --recurse-submodules

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

if has('mac')                     " Fix cursor shapes for Terminal on macOS:
  let &t_SI.="\e[5 q"             " SI = INSERT mode
  let &t_SR.="\e[4 q"             " SR = REPLACE mode
  let &t_EI.="\e[1 q"             " EI = NORMAL mode (ELSE)

  " Make :terminal source .bash_profile on macOS
  set shell=/bin/bash\ --rcfile\ ~/.bash_profile
endif

set tags=./tags;                  " Look for tags files starting in directory of current file and up
set tagcase=match                 " Make tags file search case-sensitive

set smoothscroll                  " Make scrolling work when wrap is set
set autoread                      " Automatically read a file if it's changed outside of Vim

augroup CursorLine                " Make it so that only active window has cursorline
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END

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
nmap <silent> <C-w>n :vertical new<CR>

" A more ergonomic mapping for returning to a previous position in the jump list:
nmap gr <C-o>

" Neuter ZZ because it's too dangerous:
nnoremap ZZ zz

" Expand %% on the command line to current file's directory path:
cnoremap %% <C-r>=expand('%:p:h')<CR>

" Indent current selection using Tab, de-indent using Shift-Tab:
vnoremap <silent> <Tab> VVgv>gv
vnoremap <silent> <S-Tab> VVgv<gv

" Shortcut to create a new tab:
nmap <silent> <C-w>a :tabnew<CR>
nmap <silent> <C-w>m :wincmd v<Bar>wincmd T<Bar>silent! tabmove -1<CR>
tmap <silent> <C-w>m <C-w>:wincmd v<Bar>wincmd T<Bar>silent! tabmove -1<CR>

" Close NERDTree before expanding windows horizontally lest it be crippled:
nmap <silent> <C-w>\| :NERDTreeClose<Bar>wincmd \|<CR>

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
tmap jj <Esc>

" Experiment with <Leader>w as wincmd
nmap <Leader>w <C-w>
vmap <Leader>w <C-w>

" Map <Leader>c to clear and redraw the screen,
" fix broken syntax highlighting, and get rid of stale lint errors:
nnoremap <silent> <Leader>c <C-l>:syntax sync fromstart<CR>:ALELint<CR>

" Make <Esc> switch from Terminal to Terminal-Normal mode:
tnoremap <Esc> <C-w>N
" To still be able to send Esc to the terminal job itself:
tnoremap <C-w><Esc> <Esc>

cnoremap <expr> <C-p> wildmenumode() ? '<C-p>' : '<Up>'
cnoremap <expr> <C-n> wildmenumode() ? '<C-n>' : '<Down>'

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
    let cmd = cmd . ' -F -i'
  endif
  let str = input('Search ' . getcwd() . '>', txt)
  if empty(str)
    redraw!
  else
    call writefile([str], expand('~/.vimsearch'))
    call feedkeys(cmd)
  endif
endfunction

" vim-fugitive plugin settings:
nmap <silent> <Leader>gg :tab Git<Bar>silent! tabmove -1<CR>
nmap <silent> <Leader>gb :Git blame<CR>
nmap <silent> <Leader>gv :GV -99<CR>

" vim-gitgutter plugin settings:
set updatetime=100
nmap <silent> <Leader>hz :GitGutterFold<CR>
nmap <silent> <Leader>hl :GitGutterLineHighlightsToggle<CR>
nmap <silent> <Leader>hh :GitGutterToggle<CR>
nmap <silent> <Leader>hq :GitGutterQuickFix<Bar>botright copen<CR>

" vim-easymotion plugin settings:
let g:EasyMotion_leader_key = '<Space>'
nmap <Space><Space>j <Plug>(easymotion-overwin-line)
nmap <Space><Space>k <Plug>(easymotion-overwin-line)
nmap <Space><Space>w <Plug>(easymotion-overwin-w)
nmap <Space><Space>b <Plug>(easymotion-overwin-w)
nmap <Space><Space>f <Plug>(easymotion-overwin-f)
nmap <Space><Space>s <Plug>(easymotion-overwin-f)

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
nmap <silent> <C-t> :NERDTreeToggle<CR>
nmap <silent> <Leader>t :NERDTreeToggle<CR>
nmap <silent> <C-f> :NERDTreeFind<Bar>wincmd p<Bar>wincmd p<CR>
nmap <silent> <Leader>f :NERDTreeFind<Bar>wincmd p<Bar>wincmd p<CR>

" emmet-vim plugin settings:
let g:emmet_install_only_plug = 1
imap <C-\><C-\> <plug>(emmet-expand-abbr)
vmap <C-\><C-\> <plug>(emmet-expand-abbr)
imap <C-\><C-]> <plug>(emmet-move-next)
imap <C-\><C-[> <plug>(emmet-move-prev)

" When emmet-expand-abbr expands to something like <div>|</div>, it helps
" to map Ctrl-Enter to break current line and start a new line in-between:
imap <C-Enter> <CR><Esc>O<C-g>u

" Disable the built-in Netrw plugin
let g:loaded_netrwPlugin = 1

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
      \   'elixir': ['mix_format'],
      \   'eelixir': ['mix_format'],
      \ }

let g:ale_lint_on_save = 1
let g:ale_linters_explicit = 1
let g:ale_linters = {
      \   'javascript': ['eslint', 'tsserver'],
      \   'typescript': ['tsserver'],
      \   'typescriptreact': ['tsserver'],
      \   'ruby': ['ruby'],
      \   'elixir': ['elixir-ls'],
      \ }

let g:ale_javascript_eslint_options="--rule 'no-debugger: off, import/no-unused-modules: off'"
let g:ale_elixir_elixir_ls_release = expand('~/github/elixir-ls/rel')
let g:ale_elixir_elixir_ls_config = {'elixirLS': {'dialyzerEnabled': v:false}}

let g:ale_lint_on_enter = 0
let g:ale_lint_on_filetype_changed = 0
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_text_changed = 0

let g:ale_set_highlights = 0
let g:ale_set_balloons = 0
let g:ale_hover_cursor = 0

nmap <F1> :ALEHover<CR>

nmap gd         :ALEGoToDefinition<CR>
nmap <C-w>d     :ALEGoToDefinition -vsplit<CR>
nmap <C-w><C-d> :ALEGoToDefinition -split<CR>
nmap <C-w>gd    :ALEGoToDefinition -tab<CR>

imap <expr> <C-@> ((pumvisible())?("\<C-n>"):("\<Plug>(ale_complete)"))
imap <expr> <C-Space> ((pumvisible())?("\<C-n>"):("\<Plug>(ale_complete)"))
inoremap <expr> <C-j> ((pumvisible())?("\<C-n>"):("\<C-j>"))
inoremap <expr> <C-k> ((pumvisible())?("\<C-p>"):("\<C-k>"))

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

augroup ALEProgress
  autocmd!
  autocmd User ALELintPost redrawstatus
augroup END

" targets.vim plugin settings:
autocmd User targets#mappings#user call targets#mappings#extend({
      \   'a': {'argument': [{'o': '[{([]', 'c': '[])}]', 's': ','}]},
      \   'b': {'pair': [{'o':'(', 'c':')'}]},
      \   'q': {},
      \ })

" vim-wheel plugin settings:
let g:wheel#map#mouse = 0
let g:wheel#scroll_on_wrap = 0
let g:wheel#map#left = '<C-h>'
let g:wheel#map#right = '<C-l>'

" vim-test plugin settings:
let g:test#enabled_runners = ['elixir#exunit']

function! TestStrategyPopup(cmd)
  let g:floaterm_title = ' '.a:cmd.' '
  execute 'FloatermNew --autoclose=0 --width=0.9 --height=0.9 '.a:cmd
endfunction

function! TestStrategySplit(cmd)
  execute 'AsyncRun -mode=term -pos=right -focus=0 '.a:cmd
endfunction

function! TestStrategyTab(cmd)
  execute 'AsyncRun -mode=term -pos=TAB '.a:cmd
  nnoremap <buffer> q :q<CR>
  nnoremap <buffer> <C-c> :q<CR>
endfunction

let g:test#custom_strategies = {
      \   'test-strategy-split': function('TestStrategySplit'),
      \   'test-strategy-popup': function('TestStrategyPopup'),
      \   'test-strategy-tab': function('TestStrategyTab'),
      \ }

let g:test#strategy = 'test-strategy-split'

function! TestStrategy()
  let g:test#strategy = {
        \   'test-strategy-split': 'test-strategy-popup',
        \   'test-strategy-popup': 'test-strategy-tab',
        \   'test-strategy-tab': 'test-strategy-split',
        \ }[g:test#strategy]

  echo g:test#strategy
endfunction

function! TestMode(mode)
  if a:mode == 'debug'
    let g:test#elixir#exunit#executable = 'iex --dbg pry -S mix test'
    let g:test#elixir#exunit#options = '--trace'
  elseif a:mode == 'trace'
    let g:test#elixir#exunit#executable = 'mix test'
    let g:test#elixir#exunit#options = '--trace'
  else
    let g:test#elixir#exunit#executable = 'mix test'
    let g:test#elixir#exunit#options = ''
  endif
endfunction

nmap <silent> <Space>n :write<Bar>call TestMode('quiet')<Bar>TestNearest<CR>
nmap <silent> <Space>a :write<Bar>call TestMode('quiet')<Bar>TestFile<CR>
nmap <silent> <Space>u :write<Bar>call TestMode('quiet')<Bar>TestSuite<CR>

nmap <silent> <Space>N :write<Bar>call TestMode('trace')<Bar>TestNearest<CR>
nmap <silent> <Space>A :write<Bar>call TestMode('trace')<Bar>TestFile<CR>
nmap <silent> <Space>U :write<Bar>call TestMode('trace')<Bar>TestSuite<CR>

nmap <silent> <Space>d :write<Bar>call TestMode('debug')<Bar>TestNearest<CR>
nmap <silent> <Space>l :write<Bar>TestLast<CR>
nmap <silent> <Space>v :TestVisit<CR>

nmap <silent> <F2> :call TestStrategy()<CR>
nmap <silent> <F12> :FloatermShow<CR>

" QFEnter plugin settings:
let g:qfenter_keymap = {}
let g:qfenter_keymap.open = ['<CR>', '<2-LeftMouse>']
let g:qfenter_keymap.vopen = ['<C-w><CR>']
let g:qfenter_keymap.hopen = ['<C-w><Space>']
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

let g:projectionist_heuristics = {
      \   'mix.exs': {
      \     'lib/*.ex': {
      \       'type': 'source',
      \       'alternate': 'test/{}_test.exs',
      \       'template': [
      \         'defmodule {camelcase|capitalize|dot} do',
      \         'end'
      \       ]
      \     },
      \     'test/*_test.exs': {
      \       'type': 'test',
      \       'alternate': 'lib/{}.ex',
      \       'template': [
      \         'defmodule {camelcase|capitalize|dot}Test do',
      \         '  use ExUnit.Case, async: true',
      \         '',
      \         '  alias {camelcase|capitalize|dot}',
      \         'end'
      \       ]
      \     }
      \   }
      \ }

" colorscheme settings:
function! OverrideColorscheme() abort
  highlight Terminal        guibg=#000000
  highlight GitGutterAdd    guifg=#009900 ctermfg=2
  highlight GitGutterChange guifg=#bbbb00 ctermfg=3
  highlight GitGutterDelete guifg=#ff2222 ctermfg=1
  highlight TabLineSel      guifg=#1c1c1c guibg=#9e9e9e gui=NONE ctermfg=234 ctermbg=247 cterm=NONE
  highlight Directory       guifg=#87af87 guibg=NONE    gui=bold ctermfg=108 ctermbg=NONE cterm=bold
endfunction

augroup ColorschemeOverrides
  autocmd!
  autocmd ColorScheme habamax call OverrideColorscheme()
augroup END

colorscheme habamax
