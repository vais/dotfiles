call ai_term#setup({'prompt_pattern': '^› '})

" Temporarily neuter <C-d> in Codex:
" (hopefully they will fix forward delete, so we can remap in the future)
tmap <buffer> <C-d> <nop>
