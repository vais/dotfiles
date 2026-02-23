local function hi_fg_from(source, target)
  local fg = vim.fn.synIDattr(vim.fn.hlID(source), 'fg#')
  local ctermfg = vim.fn.synIDattr(vim.fn.hlID(source), 'fg', 'cterm')

  if fg == '' and ctermfg == '' then
    vim.cmd(('highlight! link %s %s'):format(target, source))
    return
  end

  if fg ~= '' then
    vim.cmd(('highlight! %s guifg=%s guibg=NONE gui=NONE'):format(target, fg))
  end
  if ctermfg ~= '' then
    vim.cmd(('highlight! %s ctermfg=%s ctermbg=NONE cterm=NONE'):format(target, ctermfg))
  end
end

local function hi_bg_to_fg_from(source, target)
  local id = vim.fn.hlID(source)
  local reverse = vim.fn.synIDattr(id, 'reverse') == '1'

  local bg = vim.fn.synIDattr(id, reverse and 'fg#' or 'bg#')
  local ctermbg = vim.fn.synIDattr(id, reverse and 'fg' or 'bg', 'cterm')

  if bg ~= '' then
    vim.cmd(('highlight! %s guifg=%s guibg=NONE gui=NONE'):format(target, bg))
  end
  if ctermbg ~= '' then
    vim.cmd(('highlight! %s ctermfg=%s ctermbg=NONE cterm=NONE'):format(target, ctermbg))
  end
end

local function disable_bold_and_italic()
  for _, name in ipairs(vim.fn.getcompletion('', 'highlight')) do
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
    if ok and hl and next(hl) ~= nil then
      if hl.bold or hl.italic then
        hl.bold = false
        hl.italic = false
        vim.api.nvim_set_hl(0, name, hl)
      end
    end
  end
end

local function hi_copy(source, target)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = source, link = false })
  if not ok or not hl or next(hl) == nil then
    vim.cmd(('highlight! link %s %s'):format(target, source))
    return
  end

  hl.link = nil
  vim.api.nvim_set_hl(0, target, hl)
end

local function apply_colorscheme_overrides()
  -- Keep colorscheme backgrounds for full-line GitGutter highlights.
  vim.cmd('highlight! link GitGutterAddLine DiffAdd')
  vim.cmd('highlight! link GitGutterAddLineNr DiffAdd')
  vim.cmd('highlight! link GitGutterAddIntraLine DiffAdd')
  vim.cmd('highlight! link GitGutterChangeLine DiffChange')
  vim.cmd('highlight! link GitGutterChangeLineNr DiffChange')
  vim.cmd('highlight! link GitGutterChangeDeleteLine DiffChange')
  vim.cmd('highlight! link GitGutterChangeDeleteLineNr DiffChange')
  vim.cmd('highlight! link GitGutterDeleteLine DiffDelete')
  vim.cmd('highlight! link GitGutterDeleteLineNr DiffDelete')
  vim.cmd('highlight! link GitGutterDeleteIntraLine DiffDelete')

  hi_fg_from('DiffAdd', 'Added')
  hi_fg_from('DiffChange', 'Changed')
  hi_fg_from('DiffDelete', 'Removed')

  vim.cmd('highlight! link diffAdded Added')
  vim.cmd('highlight! link gitDiffAdded Added')
  vim.cmd('highlight! link GitGutterAdd Added')
  vim.cmd('highlight! link diffChanged Changed')
  vim.cmd('highlight! link gitDiffChanged Changed')
  vim.cmd('highlight! link GitGutterChange Changed')
  vim.cmd('highlight! link GitGutterChangeDelete Changed')
  vim.cmd('highlight! link diffRemoved Removed')
  vim.cmd('highlight! link gitDiffRemoved Removed')
  vim.cmd('highlight! link GitGutterDelete Removed')

  -- Re-apply ALE highlights.
  vim.cmd('highlight link ALEErrorSign error')
  vim.cmd('highlight link ALEStyleErrorSign ALEErrorSign')
  vim.cmd('highlight link ALEWarningSign todo')
  vim.cmd('highlight link ALEStyleWarningSign ALEWarningSign')
  vim.cmd('highlight link ALEInfoSign ALEWarningSign')
  vim.cmd('highlight link ALESignColumnWithErrors error')
  vim.cmd('highlight link ALEVirtualTextError Comment')
  vim.cmd('highlight link ALEVirtualTextStyleError ALEVirtualTextError')
  vim.cmd('highlight link ALEVirtualTextWarning Comment')
  vim.cmd('highlight link ALEVirtualTextStyleWarning ALEVirtualTextWarning')
  vim.cmd('highlight link ALEVirtualTextInfo ALEVirtualTextWarning')

  -- Keep folds visually lightweight (comment-like fg, no block background fill).
  hi_fg_from('Comment', 'Folded')
  hi_fg_from('Comment', 'FoldColumn')
  hi_fg_from('Comment', 'CursorLineFold')

  -- Keep floating previews/popups on the colorscheme background.
  vim.cmd('highlight! NormalFloat guibg=bg ctermbg=bg')
  vim.cmd('highlight! FloatBorder guibg=bg ctermbg=bg')
  vim.cmd('highlight! FloatTitle guibg=bg ctermbg=bg')

  -- Keep flash match and jump-target highlights distinct while unifying search highlights.
  vim.cmd('highlight! link FlashBackdrop Comment')
  hi_copy('IncSearch', 'FlashCurrent')
  vim.cmd('highlight! link FlashLabel FlashCurrent')
  vim.cmd('highlight! link FlashMatch Search')
  vim.cmd('highlight! link IncSearch Search')
  vim.cmd('highlight! link CurSearch Search')

  -- Make split separators a thin line whose color matches inactive statusline background.
  hi_bg_to_fg_from('StatusLineNC', 'VertSplit')
  hi_bg_to_fg_from('StatusLineNC', 'WinSeparator')

  -- Keep typography neutral regardless of colorscheme defaults.
  disable_bold_and_italic()
end

local function apply_retrobox_overrides()
  if vim.o.background == 'dark' then
    vim.cmd('highlight Added   guifg=#8ec07c guibg=NONE gui=NONE ctermfg=107 ctermbg=NONE cterm=NONE')
    vim.cmd('highlight Changed guifg=#fabd2f guibg=NONE gui=NONE ctermfg=214 ctermbg=NONE cterm=NONE')
    vim.cmd('highlight Removed guifg=#fb5944 guibg=NONE gui=NONE ctermfg=203 ctermbg=NONE cterm=NONE')
    vim.cmd('highlight Search guifg=#1c1c1c guibg=#98971a gui=NONE ctermfg=234 ctermbg=100 cterm=NONE')
  else
    vim.cmd('highlight Added   guifg=#427b58 guibg=NONE gui=NONE ctermfg=29 ctermbg=NONE cterm=NONE')
    vim.cmd('highlight Changed guifg=#076678 guibg=NONE gui=NONE ctermfg=23 ctermbg=NONE cterm=NONE')
    vim.cmd('highlight Removed guifg=#9d0006 guibg=NONE gui=NONE ctermfg=88 ctermbg=NONE cterm=NONE')
    vim.cmd('highlight Search guifg=#fbf1c7 guibg=#98971a gui=NONE ctermfg=230 ctermbg=100 cterm=NONE')
  end

  vim.cmd('highlight link GitCommitSummary Title')
end

local group = vim.api.nvim_create_augroup('ConfigureColorscheme', { clear = true })
vim.api.nvim_create_autocmd('ColorScheme', {
  group = group,
  pattern = '*',
  callback = apply_colorscheme_overrides,
})
vim.api.nvim_create_autocmd('ColorScheme', {
  group = group,
  pattern = 'retrobox',
  callback = apply_retrobox_overrides,
})

-- Use built-in Retrobox as the active colorscheme.
vim.cmd.colorscheme('retrobox')
