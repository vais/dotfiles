set background=dark

colorscheme solarized

" Style folded text using the same rules solarized uses to style comments:
hi! Folded gui=NONE,italic term=NONE,italic guifg=#586e75 guibg=NONE

let g:solarized_diffmode='high' " Legible diffs for the solarized color scheme.

set guicursor+=a:blinkon0       " Switch off cursor blinking for all modes.

set guioptions-=m               " Remove menu bar.
set guioptions-=T               " Remove toolbar.
set guioptions-=e               " Do not use gui tabs.
set guioptions+=r               " Always show right scrollbar.
set guioptions+=b               " Always show bottom scrollbar.
set guioptions-=l               " Never show left scrollbar.
set guioptions-=L               " Never show left scrollbar.

augroup CursorLine
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END

if has('win32') || has('win64') " Set GUI preferences unique to each OS:

  set guifont=Courier_New:h10:cANSI

elseif has('mac')

  set guifont=Monaco:h14
  set guioptions-=b             " Turn off bottom scrollbars on gui macvim
  set guioptions+=e             " Use gui tabs on gui macvim

  " Make :terminal source .bash_profile on macOS:
  set shell=/bin/bash\ --rcfile\ ~/.bash_profile

  " Unmap default menu mappings:
  macmenu &Edit.Cut   key=<nop>
  macmenu &Edit.Copy  key=<nop>
  macmenu &Edit.Paste key=<nop>

elseif has('unix')

  let &guifont='Monospace 10'

endif
