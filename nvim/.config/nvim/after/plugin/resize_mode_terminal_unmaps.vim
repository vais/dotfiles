" Keep vim-resize-mode in normal mode, but remove terminal <C-w> mappings
" so terminal insert-mode <C-w> behaves like shell word-delete without delay.
silent! tunmap <C-W>+
silent! tunmap <C-W><kPlus>
silent! tunmap <C-W>-
silent! tunmap <C-W><kMinus>
silent! tunmap <C-W>>
silent! tunmap <C-W><
