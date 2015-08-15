runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

set nocompatible                  " Must come first because it changes other options.
set modelines=0
set shortmess+=I                  " No startup splashscreen please.

syntax enable                     " Turn on syntax highlighting.
filetype plugin indent on         " Turn on file type detection.
set smartindent
set autoindent

runtime macros/matchit.vim        " Load the matchit plugin.

set showcmd                       " Display incomplete commands.
set showmode                      " Display the mode you're in.

set backspace=indent,eol,start    " Intuitive backspacing.

set hidden                        " Handle multiple buffers better.

set wildmenu                      " Enhanced command line completion.
set wildmode=list:longest         " Complete files like a shell.

set ignorecase                    " Case-insensitive searching.
set smartcase                     " But case-sensitive if expression contains a capital letter.

set number                        " Show line numbers.
set ruler                         " Show cursor position.

set incsearch                     " Highlight first match as you type.
set nohlsearch                    " Do not highlight matches.

set nowrap                        " Turn off line wrapping.
set linebreak

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

set smarttab
set expandtab
set shiftround
set tabstop=2
set softtabstop=2
set shiftwidth=2

set laststatus=2
" use this info to hack on the status line:
" http://got-ravings.blogspot.com/2008/08/vim-pr0n-making-statuslines-that-own.html
" http://got-ravings.blogspot.com/search/label/statuslines
" set statusline=[%n]\ %<%.99f\ %h%w%1*%m%*%#error#%r%*%y\ %{exists('*CapsLockStatusline')?CapsLockStatusline():''}%=%-16(\ %l,%c-%v\ %)%P
" Keep the status line short, so you can see the file path
" when there are several vertical splits:
set statusline=[%n]\ %<%.99f\ %h%w%1*%m%*%#error#%r%*

let g:EasyMotion_leader_key = '<Leader>'

cnoremap %% <C-R>=expand('%:p:h')<cr>

" Omnicompletion stuff
set complete=.,w,b
set completeopt=menuone
inoremap <expr> <Tab> pumvisible() ? "\<C-y>" : "\<Tab>"
let g:acp_behaviorKeywordLength = 3
let g:acp_behaviorRubyOmniMethodLength = -1
let g:acp_behaviorRubyOmniSymbolLength = -1
let g:acp_behaviorHTMLOmniLength = -1

" added to enable completing ruby minitest assertions with CTRL-X CTRL-U
set completefunc=syntaxcomplete#Complete

" CtrlP stuff
let g:ctrlp_working_path_mode = 0
let g:ctrlp_clear_cache_on_exit = 0
nnoremap <silent> <Space> :let g:ctrlp_max_height = 100<Bar>
  \CtrlPBuffer<Bar>
  \let g:ctrlp_max_height = 10<CR>

set history=420
set mouse=a

if has('gui_running')
    colorscheme solarized
    let g:solarized_diffmode="high"
    set background=dark
    " set cursorline
    " if has('autocmd')
    "     autocmd WinEnter * setlocal cursorline
    "     autocmd WinLeave * setlocal nocursorline
    " endif
    set guicursor+=a:blinkon0
    if has('win32') || has('win64')
        set guifont=Courier_New:h10:cANSI
    elseif has('gui_macvim')
        set guifont=Menlo:h12
    elseif has('unix')
        let &guifont="Monospace 10"
    endif

    set guioptions-=m "remove menu bar
    set guioptions-=T "remove toolbar
    set guioptions-=e "do not use gui tabs
    set guioptions+=r "always show right scrollbar
    set guioptions+=b "always show bottom scrollbar
    set guioptions-=l "never show left scrollbar
    set guioptions-=L "never show left scrollbar

    " Hilight for [+] in the status line
    hi User1 guibg=yellow guifg=black
endif


nnoremap ZZ zz
" Because ZZ is too dangerous:
" ZZ writes all changes and quits,
" zz scrolls the current line to the center of screen.

nmap <silent> g6 :let @t=@@<CR>yygccp:let @@=@t<CR>
vmap <silent> g6 :<C-u>let @t=@@<CR>gvVVgvygvgc`]p:let @@=@t<CR>

nmap <silent> g5 :let @t=@@<CR>yyp:let @@=@t<CR>
vmap <silent> g5 :<C-u>let @t=@@<CR>gvy`]p:<C-u>let @@=@t<CR>gv

vnoremap <silent> <Tab> VVgv>gv
vnoremap <silent> <S-Tab> VVgv<gv

" Window zooming
set winminheight=1
set winminwidth=1
nnoremap <C-w>\ <C-w><C-bar>
nnoremap <C-w>- <C-w><C-_>
nnoremap <C-w>0 <C-w><C-_><C-w><C-bar>
nnoremap <silent> <C-w>a :tabnew<CR>

nnoremap <F8> :ccl<Bar>lcl<CR>

vnoremap <C-X> "+x
vnoremap <C-C> "+y
vnoremap <C-V> "+p
nnoremap <C-V> "+p
inoremap <C-V> <C-R>+
cnoremap <C-V> <C-R>+

" Search for selected text, forwards or backwards.
" Adapted from http://vim.wikia.com/wiki/Search_for_visually_selected_text
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

set grepprg=grep\ -I\ -n\ -H\ --mmap

nnoremap <F3> :call VimSearch('')<CR>
nnoremap <S-F3> :call VimSearch(expand("<cword>"))<CR>
vnoremap <F3> :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy:let txt=getreg('"')<Bar>call setreg('"', old_reg, old_regtype)<CR>
  \gv
  \:call VimSearch(txt)<CR>

function! VimSearch(text)
    let str = input('Search ' . getcwd() . '>', a:text)
    if !empty(str)
        call VimSearchWrite(str)
        " call feedkeys(':copen10 | silent grep! --exclude-dir="node_modules/*" --exclude-dir="lib/*" -f "' . expand('~/.vimsearch') . '" -i -F -r *')
        call feedkeys(':copen10 | silent grep! -f "' . expand('~/.vimsearch') . '" -i -F -r *')
    else
        redraw!
    endif
endfunction
function! VimSearchWrite(str)
    call writefile([a:str], expand('~/.vimsearch'))
endfunction

set sessionoptions=blank,buffers,curdir,help,resize,tabpages,winsize

nmap gn *N
vmap gn *N
nmap gN #N
vmap gN #N
nmap <silent> gh :se hls!<CR>

set splitbelow
set splitright

set foldlevel=99
set foldlevelstart=99
set foldminlines=0
set foldcolumn=0
set foldmethod=indent

let g:SimpleJsIndenter_BriefMode = 1
let g:SimpleJsIndenter_CaseIndentLevel = -1

let g:AutoPairsCenterLine = 0
let g:AutoPairsFlyMode = 0
let g:AutoPairShortcutToggle = ''
let g:AutoPairsShortcutFastWrap = ''
let g:AutoPairsShortcutJump = ''
let g:AutoPairsShortcutBackInsert = ''

let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1
let NERDTreeMinimalUI = 1
let NERDTreeHijackNetrw = 0
let NERDTreeHighlightCursorline = 0
nmap <silent> <C-N>t :NERDTreeToggle<CR>
nmap <silent> <C-N><C-t> :NERDTreeToggle<CR>
nmap <silent> <C-N>f :NERDTreeFind<CR>
nmap <silent> <C-N><C-f> :NERDTreeFind<CR>
nmap <silent> <C-N>m :NERDTreeMirror<CR>
nmap <silent> <C-N><C-m> :NERDTreeMirror<CR>

nmap <Leader>M :g/<C-Q><C-M>$/s///<CR>:set ff=dos<CR>

cabbr cho silent! exe "!tf checkout /lock:checkout \"%\"" <Bar> edit!
cabbr chin silent! exe "!tf checkin"
cabbr tfu silent! exe "!tf undo \"%\"" <Bar> edit!
cabbr tfdf silent! exe "!start /min tf diff \"%\""

if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
endif

" Fall back to the old regexp engine to make ruby syntax highlighting fast again:
if exists("&regexpengine")
  set regexpengine=1
endif

inoremap <buffer> <silent> ;; <C-g>u<Esc>:call setline('.', getline('.') . ';')<CR>gi<C-g>u
inoremap <buffer> <silent> ,, <C-g>u<Esc>:call setline('.', getline('.') . ',')<CR>gi<C-g>u

" Annoyances:
"
" when there are horizontal splits and copen or lopen, doing ccl or lcl
" resizes the splits to be equal size and messes up the manual layout.
"
" How to open files from quickfix list in a new tab, vert and horiz splits??
"
" In CtrlP if a file is already open buffer, choosing it from list of open
" buffers while in another tab takes you back to the tab where it is already
" open. How to avoid this and open in the current tab instead?
"
" File name autocomplete is relative to the cwd - how to make it relative to
" the directory of the file in buffer?
