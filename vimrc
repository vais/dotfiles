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
set directory=~/.vimswap//
if !isdirectory(&directory)
  call mkdir(&directory)
endif

set virtualedit=block             " Allow virtual editing in Visual Block mode.

set smarttab                      " <Tab> in front of a line inserts blanks according to 'shiftwidth'.
set expandtab                     " Use the appropriate number of spaces to insert a <Tab>.
set shiftround                    " Round indent to multiple of 'shiftwidth'.
set tabstop=2                     " Number of spaces that a <Tab> in the file counts for.
set softtabstop=2                 " Number of spaces that a <Tab> counts for while performing editing operations.
set shiftwidth=2                  " Number of spaces to use for each step of (auto)indent.

set laststatus=2                  " Always show the status line.
set statusline=[%n]\ %<%.99f\ %h%w%1*%m%*%#error#%r%*

set complete=.,w,b                " Auto-complete from all currently loaded buffers.
set completeopt=menuone,noselect,noinsert

set history=420                   " The number of commands and search patterns to keep in history.

set mouse=a                       " Enable the use of the mouse in all modes.

set noequalalways                 " Don't make all windows same size after splitting or closing a window.
set winminheight=1                " The minimal height of a window, when it's not the current window.
set winminwidth=1                 " The minimal width of a window, when it's not the current window.

let &grepprg='grep -f "' . expand('~/.vimsearch') . '"' " --file=FILE (obtain PATTERN from FILE)
set grepprg+=\ -I                 " --binary-files=without-match
set grepprg+=\ -n                 " --line-number (print line number with output lines)
set grepprg+=\ -H                 " --with-filename (print the file name for each match)
set grepprg+=\ -r                 " --recursive
set grepprg+=\ --exclude=tags     " --exclude=FILE_PATTERN (skip files and directories matching FILE_PATTERN)
set grepprg+=\ --exclude-dir=.git " --exclude-dir=PATTERN (directories that match PATTERN will be skipped)
set grepprg+=\ --exclude-dir=node_modules

set sessionoptions-=blank         " Forget empty windows (e.g. NERDTree, quickfix, etc.)
set sessionoptions+=resize        " Remember the size of the whole Vim window

set splitbelow                    " Splitting a window will put the new window below the current one.
set splitright                    " Splitting a window will put the new window right of the current one.

set foldlevel=99                  " Auto-close folds at levels deeper than this number.
set foldlevelstart=99             " Sets 'foldlevel' when starting to edit another buffer in a window.
set foldminlines=1                " A fold can only be closed if it takes up two or more screen lines (this is the default).
set foldcolumn=0                  " Do not show a column at the side of the window to indicate open and closed folds.
set foldmethod=indent             " Lines with equal indent form a fold.
set foldtext=                     " Show only the most basic text to represent a fold.

if has('mac')                     " Fix cursor shapes for Terminal on macOS:
  let &t_SI.="\e[5 q"             " SI = INSERT mode
  let &t_SR.="\e[4 q"             " SR = REPLACE mode
  let &t_EI.="\e[1 q"             " EI = NORMAL mode (ELSE)
endif

set tags=./tags;                  " Look for tags files starting in directory of current file and up
set tagcase=match                 " Make tags file search case-sensitive

set termwinsize=2*1024            " Prevent clipped/garbled output when Terminal window is resized

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

" Map CTRL-W-F to go to file in a vertical split:
nmap <C-W>f :vertical wincmd f<CR>

" Neuter ZZ because it's too dangerous:
nnoremap ZZ zz

" Expand %% on the command line to current file's directory path:
cnoremap %% <C-r>=expand('%:p:h')<CR>

" Indent current selection using Tab, de-indent using Shift-Tab:
vnoremap <silent> <Tab> VVgv>gv
vnoremap <silent> <S-Tab> VVgv<gv

" Shortcut to create a new tab:
nnoremap <silent> <C-w>a :tabnew<CR>
tnoremap <silent> <C-w>a <C-w>:tabnew<CR>

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

" Map Leader-. to source the project .vimrc
nnoremap <silent> <Leader>. :call project_vimrc#SourceProjectVimrc()<CR>

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

" Remap F1 to Esc
nnoremap <F1> <Esc>
inoremap <F1> <Esc>
vnoremap <F1> <Esc>

" Map jj to Esc
inoremap jj <Esc>

" Make <Esc> switch from Terminal to Terminal-Normal mode:
tnoremap <Esc> <C-W>N
tnoremap <F1>  <C-W>N
" To still be able to send Esc to the terminal job itself:
tnoremap <C-W><Esc> <Esc>

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
  let cmd = ':copen | silent grep!'
  if get(a:, 1, 0)
    if strlen(txt) == 0
      return
    endif
    let txt = '\b' . txt . '\b'
    let cmd = cmd . ' -E'
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
nmap <silent> gs :tab Git<Bar>silent! tabmove -1<CR>

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

" auto-pairs plugin settings:
let g:AutoPairsCenterLine = 0
let g:AutoPairsFlyMode = 0
let g:AutoPairShortcutToggle = ''
let g:AutoPairsShortcutFastWrap = ''
let g:AutoPairsShortcutJump = ''
let g:AutoPairsShortcutBackInsert = ''

" nerdtree plugin settings:
let NERDTreeMinimalUI = 1
let NERDTreeHijackNetrw = 0
let NERDTreeHighlightCursorline = 1
let NERDTreeShowHidden = 1
nnoremap <silent> <C-t> :NERDTreeToggle<CR>
nnoremap <silent> <C-f> :NERDTreeFind<Bar>wincmd p<Bar>wincmd p<CR>

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
let g:loaded_netrw = 1
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
\}

let g:ale_lint_on_save = 1
let g:ale_linters_explicit = 1
let g:ale_linters = {
\   'javascript': ['eslint', 'tsserver'],
\   'typescript': ['tsserver'],
\   'typescriptreact': ['tsserver'],
\   'ruby': ['ruby'],
\   'elixir': ['elixir-ls'],
\}
let g:ale_javascript_eslint_options="--rule 'no-debugger: off'"
let g:ale_elixir_elixir_ls_release = expand('~/elixir-ls/rel')
let g:ale_elixir_elixir_ls_config = {'elixirLS': {'dialyzerEnabled': v:false}}

let g:ale_open_list = 1
let g:ale_list_window_size = 5
let g:ale_keep_list_window_open = 0

let g:ale_cursor_detail = 0
let g:ale_echo_cursor = 0
let g:ale_hover_cursor = 0

let g:ale_lint_on_enter = 0
let g:ale_lint_on_filetype_changed = 0
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_text_changed = 0

let g:ale_set_balloons = 0
let g:ale_set_highlights = 0
let g:ale_set_signs = 0

nmap gd         :ALEGoToDefinition<CR>
nmap <C-W>d     :ALEGoToDefinition -vsplit<CR>
nmap <C-W><C-d> :ALEGoToDefinition -split<CR>
nmap <C-W>gd    :ALEGoToDefinition -tab<CR>

imap <expr> <C-Space> ((pumvisible())?("\<C-n>"):("\<Plug>(ale_complete)"))
inoremap <expr> <C-j> ((pumvisible())?("\<C-n>"):("\<C-j>"))
inoremap <expr> <C-k> ((pumvisible())?("\<C-p>"):("\<C-k>"))

" targets.vim settings:
autocmd User targets#mappings#user call targets#mappings#extend({
    \ 'a': {'argument': [{'o': '[{([]', 'c': '[])}]', 's': ','}]},
    \ 'b': {'pair': [{'o':'(', 'c':')'}]},
    \ 'q': {},
    \ })

colorscheme jellybeans
