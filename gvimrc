set guicursor+=a:blinkon0       " Switch off cursor blinking for all modes.

set guioptions-=m               " Remove menu bar.
set guioptions-=T               " Remove toolbar.
set guioptions-=e               " Do not use gui tabs.
set guioptions+=c               " Do not use gui dialogs.
set guioptions+=r               " Always show right scrollbar.
set guioptions+=b               " Always show bottom scrollbar.
set guioptions-=l               " Never show left scrollbar.
set guioptions-=L               " Never show left scrollbar.

if has('win32') || has('win64') " Set GUI preferences unique to each OS:

  set guifont=Consolas:h11
  set guioptions+=d

elseif has('mac')

  set guifont=Monaco:h14
  set guioptions-=b             " Turn off bottom scrollbars on gui macvim

  " Unmap default menu mappings:
  macmenu &Edit.Cut   key=<nop>
  macmenu &Edit.Copy  key=<nop>
  macmenu &Edit.Paste key=<nop>

elseif has('unix')

  let &guifont='Monospace 10'

endif
