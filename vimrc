runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

syntax enable                     " Turn on syntax highlighting.
filetype plugin indent on         " Turn on file type detection.

runtime macros/matchit.vim        " Load the matchit plugin.

set nocompatible                  " Must come first because it changes other options.
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
if has('autocmd')
  autocmd GUIEnter * set visualbell t_vb=
endif

set nobackup                      " Don't make a backup before overwriting a file.
set nowritebackup                 " And again.
set directory=~/.vimswap//
if !isdirectory(&directory)
  call mkdir(&directory)
endif

set virtualedit=block             " Allow virtual editing in Visual Block mode.

if exists('&regexpengine')        " Fall back to the old regexp engine to make Ruby syntax highlighting fast again.
  set regexpengine=1
endif

set smarttab                      " <Tab> in front of a line inserts blanks according to 'shiftwidth'.
set expandtab                     " Use the appropriate number of spaces to insert a <Tab>.
set shiftround                    " Round indent to multiple of 'shiftwidth'.
set tabstop=2                     " Number of spaces that a <Tab> in the file counts for.
set softtabstop=2                 " Number of spaces that a <Tab> counts for while performing editing operations.
set shiftwidth=2                  " Number of spaces to use for each step of (auto)indent.

set laststatus=2                  " Always show the status line.
set statusline=[%n]\ %<%.99f\ %h%w%1*%m%*%#error#%r%*

set complete=.,w,b                " Auto-complete from all currently loaded buffers.
set completeopt=menuone           " Show the popup menu even when there is only one match.

set history=420                   " The number of commands and search patterns to keep in history.

set mouse=a                       " Enable the use of the mouse in all modes.

set winminheight=1                " The minimal height of a window, when it's not the current window.
set winminwidth=1                 " The minimal width of a window, when it's not the current window.

let &grepprg='grep -f "' . expand('~/.vimsearch') . '"' " --file=FILE (obtain PATTERN from FILE)
set grepprg+=\ -I                 " --binary-files=without-match
set grepprg+=\ -n                 " --line-number (print line number with output lines)
set grepprg+=\ -H                 " --with-filename (print the file name for each match)
set grepprg+=\ -r                 " --recursive
set grepprg+=\ --exclude-dir=.git " --exclude-dir=PATTERN (directories that match PATTERN will be skipped)
set grepprg+=\ --exclude=tags     " --exclude=FILE_PATTERN (skip files and directories matching FILE_PATTERN)

set sessionoptions-=blank         " Forget empty windows (e.g. NERDTree, quickfix, etc.)
set sessionoptions+=resize        " Remember the size of the whole Vim window

set splitbelow                    " Splitting a window will put the new window below the current one.
set splitright                    " Splitting a window will put the new window right of the current one.

set foldlevel=99                  " Auto-close folds at levels deeper than this number.
set foldlevelstart=99             " Sets 'foldlevel' when starting to edit another buffer in a window.
set foldminlines=0                " Close folds of even just a single screen line.
set foldcolumn=0                  " Do not show a column at the side of the window to indicate open and closed folds.
set foldmethod=indent             " Lines with equal indent form a fold.

if has('gui_running')
  set background=dark

  colorscheme solarized
  let g:solarized_diffmode='high' " Legible diffs for the solarized color scheme.

  set guicursor+=a:blinkon0       " Switch off cursor blinking for all modes.

  set guioptions-=m               " Remove menu bar.
  set guioptions-=T               " Remove toolbar.
  set guioptions-=e               " Do not use gui tabs.
  set guioptions+=r               " Always show right scrollbar.
  set guioptions+=b               " Always show bottom scrollbar.
  set guioptions-=l               " Never show left scrollbar.
  set guioptions-=L               " Never show left scrollbar.

  if has('win32') || has('win64') " Set GUI preferences unique to each OS:
    set guifont=Courier_New:h10:cANSI
  elseif has('gui_macvim')
    set guifont=Courier_New:h17
    set guioptions-=r             " Turn off right and bottom
    set guioptions-=b             " scrollbars on gui macvim
  elseif has('unix')
    let &guifont='Monospace 10'
  endif
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

" Helper map to pass the count (e.g., 2gf) to the underlying command
" (used for GOTO-FILE and GOTO-DEFINITION mappings below)
nnoremap <SID>: :<C-U><C-R>=v:count ? v:count : ''<CR>

" GOTO-FILE mappings
" Use Vim's built-in CTRL-R_CTRL-F when no plugin has claimed <Plug><cfile>
if empty(maparg('<Plug><cfile>', 'c'))
  cnoremap <Plug><cfile> <C-R><C-F>
endif
nmap <silent> <C-W>f     <SID>:vert sfind  <Plug><cfile><CR>

" GOTO-DEFINITION mappings
" Use Vim's built-in CTRL-R_CTRL-W when no plugin has claimed <Plug><cword>
if empty(maparg('<Plug><cword>', 'c'))
  cnoremap <Plug><cword> <C-R><C-W>
endif
nmap <silent> gd         <SID>:tjump       <Plug><cword><CR>
nmap <silent> <C-W><C-D> <SID>:stjump      <Plug><cword><CR>
nmap <silent> <C-W>gd    <SID>:tab tjump   <Plug><cword><CR>
nmap <silent> <C-W>d     <SID>:vert stjump <Plug><cword><CR>
vmap <silent> gd         :<C-u>tjump       <C-R>=getline("'<")[getpos("'<")[2]-1:getpos("'>")[2]-1]<CR><CR>
vmap <silent> <C-W><C-D> :<C-u>stjump      <C-R>=getline("'<")[getpos("'<")[2]-1:getpos("'>")[2]-1]<CR><CR>
vmap <silent> <C-W>gd    :<C-u>tab tjump   <C-R>=getline("'<")[getpos("'<")[2]-1:getpos("'>")[2]-1]<CR><CR>
vmap <silent> <C-W>d     :<C-u>vert stjump <C-R>=getline("'<")[getpos("'<")[2]-1:getpos("'>")[2]-1]<CR><CR>

" A more ergonomic mapping for returning to a previous position in the jump list
nmap gr <C-O>

" Neuter ZZ because it's too dangerous:
nnoremap ZZ zz

" Expand %% on the command line to current file's directory path:
cnoremap %% <C-r>=expand('%:p:h')<CR>

" Copy current line info in cfile format to system clipboard:
nnoremap <silent> <Leader>l :let @+=expand('%:p').':'.line('.').':'.col('.').': '.substitute(getline('.'), '\v^\s*', '', '')<CR>

" Duplicate current line or visual selection:
nnoremap <silent> g5 :let @t=@@<CR>yyp:let @@=@t<CR>
vnoremap <silent> g5 :<C-u>let @t=@@<CR>gvy`]p:<C-u>let @@=@t<CR>gv

" Duplicate current line or visual selection and comment out the original:
" (using nmap and vmap because this mapping depends on the `ccp` mapping)
nmap <silent> g6 :let @t=@@<CR>yygccp:let @@=@t<CR>
vmap <silent> g6 :<C-u>let @t=@@<CR>gvVVgvygvgc`]p:let @@=@t<CR>

" Indent current selection using Tab, de-indent using Shift-Tab:
vnoremap <silent> <Tab> VVgv>gv
vnoremap <silent> <S-Tab> VVgv<gv

" Window zooming:
nnoremap <C-w>\ <C-w><C-bar>
nnoremap <C-w>- <C-w><C-_>
nnoremap <C-w>0 <C-w><C-_><C-w><C-bar>

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

" Fix mixed line endings and set DOS mode for line endings:
nnoremap <Leader>m :g/<C-q><C-m>$/s///<CR>:set ff=dos<CR>

" Diff modified buffer with the original file on disk:
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
endif

" Double-tap to put a semi-colon or comma at the end of line:
inoremap ;; <C-g>u<Esc>:call setline('.', getline('.') . ';')<CR>gi<C-g>u
inoremap ,, <C-g>u<Esc>:call setline('.', getline('.') . ',')<CR>gi<C-g>u

" Map Shift-Enter to start a new line from any position on current line:
inoremap <S-Enter> <C-g>u<Esc>o

" Map Ctrl-Enter to break current line and start a new line in-between:
inoremap <C-Enter> <CR><Esc>O<C-g>u

" Set current word or selection to be the current search term:
nnoremap <silent> gn :call SetSearchTermNormal()<CR>
vnoremap <silent> gn :<C-u>call SetSearchTermVisual()<CR>

" Toggle highlighting of all occurrences of the current search term:
nnoremap <silent> gh :set hls!<CR>

" Map F5 to save and 'make' any file type:
nmap <silent> <F5> :update<Bar>exe ":silent lmake!"<Bar>lwindow5<CR>
imap <silent> <F5> <Esc><F5>

" Remap F1 to Esc
nnoremap <F1> <Esc>
inoremap <F1> <Esc>
vnoremap <F1> <Esc>

" Make <Esc> switch from Terminal to Terminal-Normal mode:
tnoremap <Esc> <C-W>N
tnoremap <F1>  <C-W>N
" To still be able to send Esc to the terminal job itself:
tnoremap <C-W><Esc> <Esc>

" Find in files:
nnoremap <silent> <F3> :call FindInFiles('')<CR>
nnoremap <silent> <S-F3> :call FindInFiles(SetSearchTermNormal())<CR>
vnoremap <silent> <F3> :<C-u>call FindInFiles(SetSearchTermVisual())<CR>

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

function! FindInFiles(text)
  let str = input('Search ' . getcwd() . '>', a:text)
  if empty(str)
    redraw!
  else
    call writefile([str], expand('~/.vimsearch'))
    call feedkeys(':copen | silent grep! -F -i')
  endif
endfunction

" vim-easymotion plugin settings:
let g:EasyMotion_leader_key = '<Leader>'

" ctrlp.vim plugin settings:
let g:ctrlp_working_path_mode = 0
let g:ctrlp_clear_cache_on_exit = 0
nnoremap <silent> <Space> :let g:ctrlp_max_height = 100<Bar>
  \CtrlPBuffer<Bar>
  \let g:ctrlp_max_height = 10<CR>

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
nnoremap <silent> <C-n>t :NERDTreeToggle<CR>
nnoremap <silent> <C-n><C-t> :NERDTreeToggle<CR>
nnoremap <silent> <C-n>f :NERDTreeFind<CR>
nnoremap <silent> <C-n><C-f> :NERDTreeFind<CR>
nnoremap <silent> <C-n>m :NERDTreeMirror<CR>
nnoremap <silent> <C-n><C-m> :NERDTreeMirror<CR>

" vim-fugitive plugin settings:
nmap <silent> ]d :Gstatus<CR>:setlocal cursorline<CR><C-n>D
nmap <silent> [d :Gstatus<CR>:setlocal cursorline<CR><C-p>D

" emmet-vim plugin settings:
let g:emmet_install_only_plug = 1
imap <C-\><C-\> <plug>(emmet-expand-abbr)
vmap <C-\><C-\> <plug>(emmet-expand-abbr)
imap <C-\><C-]> <plug>(emmet-move-next)
imap <C-\><C-[> <plug>(emmet-move-prev)

" Disable the built-in Netrw plugin
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

" Disable the built-in Zip plugin
let g:loaded_zipPlugin = 1
let g:loaded_zip = 1

" vim-ruby plugin settings:
let g:ruby_indent_block_style = 'do'

" Hide Terminal buffers so that ls+ command
" only show modified buffers we care about:
autocmd TerminalOpen * setlocal nobuflisted

" Replace :bm with :ls+ because there's no
" way to make :bm ignore Terminal buffers:
cabbrev bm <c-r>=(getcmdtype() == ':' && getcmdpos() == 1 ? 'ls+' : 'bm')<CR>
