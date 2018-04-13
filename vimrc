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

set grepprg=grep\ -I\ -n\ -H      " Program to use for the :grep command.

set sessionoptions=blank,buffers,curdir,help,resize,tabpages,winsize

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

  if has('win32') || has('win64') " Set the preferred font for each OS.
    set guifont=Courier_New:h10:cANSI
  elseif has('gui_macvim')
    set guifont=Menlo:h12
  elseif has('unix')
    let &guifont='Monospace 10'
  endif

  set guioptions-=m               " Remove menu bar.
  set guioptions-=T               " Remove toolbar.
  set guioptions-=e               " Do not use gui tabs.
  set guioptions+=r               " Always show right scrollbar.
  set guioptions+=b               " Always show bottom scrollbar.
  set guioptions-=l               " Never show left scrollbar.
  set guioptions-=L               " Never show left scrollbar.
endif

set tags=./tags;                  " Look for tags files starting in directory of current file and up
set tagcase=match                 " Make tags file search case-sensitive

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

" Shortcuts for navigating to tags in new splits and tabs
vmap gff og]
vmap gfs ov<C-w>sgvog]
vmap gfv ov<C-w>vgvog]
vmap gft ov<C-w>s<C-w>Tgvog]

" Neuter ZZ because it's too dangerous:
nnoremap ZZ zz

" Expand %% on the command line to current file's directory path:
cnoremap %% <C-r>=expand('%:p:h')<CR>

" Copy current line info in cfile format to system clipboard:
nnoremap <silent> <Leader>cf :let @+=expand('%').':'.line('.').':'.col('.').': '.substitute(getline('.'), '\v^\s*', '', '')<CR>

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

" Cut/Copy/Paste using the system clipboard:
vnoremap <C-x> "+x
vnoremap <C-c> "+y
vnoremap <C-v> "+p
nnoremap <C-v> "+p
inoremap <C-v> <C-r>+
cnoremap <C-v> <C-r>+

" Fix mixed line endings and set DOS mode for line endings:
nnoremap <Leader>m :g/<C-q><C-m>$/s///<CR>:set ff=dos<CR>

" Diff modified buffer with the original file on disk:
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
endif

" Double-tap to put a semi-colon or comma at the end of line:
inoremap ;; <C-g>u<Esc>:call setline('.', getline('.') . ';')<CR>gi<C-g>u
inoremap ,, <C-g>u<Esc>:call setline('.', getline('.') . ',')<CR>gi<C-g>u

" Set current word or selection to be the current search term:
nnoremap <silent> gn :call SetSearchTermNormal()<CR>
vnoremap <silent> gn :<C-u>call SetSearchTermVisual()<CR>

" Toggle highlighting of all occurrences of the current search term:
nnoremap <silent> gh :set hls!<CR>

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
    call feedkeys(':copen | silent grep! -f "' . expand('~/.vimsearch') . '" * -r -F -i')
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
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1
let NERDTreeMinimalUI = 1
let NERDTreeHijackNetrw = 0
let NERDTreeHighlightCursorline = 1
nnoremap <silent> <C-n>t :NERDTreeToggle<CR>
nnoremap <silent> <C-n><C-t> :NERDTreeToggle<CR>
nnoremap <silent> <C-n>f :NERDTreeFind<CR>
nnoremap <silent> <C-n><C-f> :NERDTreeFind<CR>
nnoremap <silent> <C-n>m :NERDTreeMirror<CR>
nnoremap <silent> <C-n><C-m> :NERDTreeMirror<CR>

" vim-fugitive plugin settings:
nmap <silent> ]d :Gstatus<CR>:setlocal cursorline<CR><C-n>D
nmap <silent> [d :Gstatus<CR>:setlocal cursorline<CR><C-p>D
