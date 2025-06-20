execute "setlocal termwinsize=" . winheight(0) . "x" . winwidth(0)

" Prompt pattern
let s:prompt_pattern = '^[a-z -]*>\ '

" Fold on prompt pattern
setlocal foldmethod=expr
setlocal foldexpr=getline(v:lnum)=~s:prompt_pattern&&(v:lnum==1\|\|getline(v:lnum-1)!~s:prompt_pattern)?'>1':1
setlocal foldtext=foldtext()

" Protect buffer from being accidentally replaced by :e
cnoremap <buffer> e<CR> <CR>

" Set up autocmd to make content foldable when switching from terminal to normal mode
augroup Folding
  autocmd! * <buffer>
  autocmd ModeChanged <buffer> if mode() == 'n' | setlocal foldmethod=expr | endif
augroup END

" Move to next fold
nmap <buffer> <C-n> zj

" Move to previous fold
nnoremap <buffer> <expr> <C-p> line('.') == line('$') ? '[z' : 'zk[z'

" Undo vimrc mapping
tmap <buffer> <C-w>K <C-w>K
tmap <buffer> <C-w>J <C-w>J

