local copy_path = require('features.copy_path')
local find_in_files = require('features.find_in_files')
local keymap_helpers = require('config.keymap_helpers')
local coverflow = require('features.coverflow')
local window_sizing = require('features.window_sizing')
local scroll_navigation = require('features.scroll_navigation')
local terminal_quit_guard = require('features.terminal_quit_guard')

-- Scroll viewport left by one column.
vim.keymap.set({ 'n', 'x', 'o' }, '<C-h>', 'zh')

-- Scroll viewport right by one column.
vim.keymap.set({ 'n', 'x', 'o' }, '<C-l>', 'zl')

-- Scroll viewport down and keep cursor movement wrap-aware.
vim.keymap.set({ 'n', 'x', 'o' }, '<C-j>', function()
  return scroll_navigation.scroll_move('down')
end, { expr = true })

-- Scroll viewport up and keep cursor movement wrap-aware.
vim.keymap.set({ 'n', 'x', 'o' }, '<C-k>', function()
  return scroll_navigation.scroll_move('up')
end, { expr = true })

-- Window and split mappings.

-- A more ergonomic mapping for returning to a previous jump location.
vim.keymap.set('n', 'gr', '<C-o>', { nowait = true })

-- Go to file in a vertical split.
vim.keymap.set({'n', 'x'}, '<C-w>f', '<Cmd>vertical wincmd f<CR>')
vim.keymap.set({'n', 'x'}, '<C-w>F', '<Cmd>vertical wincmd F<CR>')

-- Make <C-w><BS> close current window like <C-w>c.
vim.keymap.set('n', '<C-w><BS>', '<C-w>c', { silent = true })
vim.keymap.set('n', '<C-w><C-BS>', '<C-w>c', { silent = true })

-- Make new buffer in a vertical split.
vim.keymap.set('n', '<C-w>n', '<Cmd>vertical new<CR>', { silent = true })

-- Make all windows equally wide.
vim.keymap.set('n', '<C-w><Space>', '<Cmd>horizontal wincmd =<CR>', { silent = true })
vim.keymap.set('n', '<C-w><C-Space>', '<Cmd>horizontal wincmd =<CR>', { silent = true })

-- Make all windows equally tall.
vim.keymap.set('n', '<C-w>=', '<Cmd>vertical wincmd =<CR>', { silent = true })
vim.keymap.set('n', '<C-w><C-=>', '<Cmd>vertical wincmd =<CR>', { silent = true })


-- Expand %% on the command line to the current file's directory path.
vim.keymap.set('c', '%%', function()
  return vim.fn.expand('%:p:h')
end, { expr = true })

-- Indent or de-indent the full current visual-line selection.
vim.keymap.set('x', '<Tab>', 'VVgv>gv', { silent = true })
vim.keymap.set('x', '<S-Tab>', 'VVgv<gv', { silent = true })

-- Shortcut to create a new tab.
vim.keymap.set('n', '<C-w>a', '<Cmd>tabnew<CR>', { silent = true })
vim.keymap.set('n', '<C-w><C-a>', '<Cmd>tabnew<CR>', { silent = true })
vim.keymap.set('n', '<C-w>A', '<Cmd>-1tabnew<CR>', { silent = true })

-- Move current window to its own tab and position it left.
vim.keymap.set('n', '<C-w>m', '<Cmd>wincmd v | wincmd T | silent! tabmove -1<CR>', { silent = true })
vim.keymap.set('n', '<C-w><C-m>', '<Cmd>wincmd v | wincmd T | silent! tabmove -1<CR>', { silent = true })
vim.keymap.set('n', '<C-w>M', '<Cmd>wincmd v | wincmd T<CR>', { silent = true })


-- Resize window to fit content width.
vim.keymap.set('n', '<C-w>e', window_sizing.fit_current_window_to_content_width, { silent = true })
vim.keymap.set('n', '<C-w><C-e>', window_sizing.fit_current_window_to_content_width, { silent = true })

-- Coverflow(tm)-style navigation for splits.
vim.keymap.set('n', [[<C-w>\]], coverflow.equalize_and_focus_right, { silent = true })
vim.keymap.set('x', [[<C-w>\]], coverflow.equalize_and_focus_right, { silent = true })

vim.keymap.set('n', '<C-w><C-\\>', coverflow.equalize_and_focus_right, { silent = true })
vim.keymap.set('x', '<C-w><C-\\>', coverflow.equalize_and_focus_right, { silent = true })

vim.keymap.set('n', '<C-w>]', coverflow.focus_right, { silent = true })
vim.keymap.set('x', '<C-w>]', coverflow.focus_right, { silent = true })

vim.keymap.set('n', '<C-w><C-]>', coverflow.focus_right, { silent = true })
vim.keymap.set('x', '<C-w><C-]>', coverflow.focus_right, { silent = true })

vim.keymap.set('n', '<C-w>[', coverflow.focus_left, { silent = true })
vim.keymap.set('x', '<C-w>[', coverflow.focus_left, { silent = true })


-- Quickfix window mappings.
vim.keymap.set('n', '<Leader>co', '<Cmd>botright copen<CR>', { silent = true })
vim.keymap.set('n', '<Leader>cq', '<Cmd>cclose<CR>', { silent = true })
vim.keymap.set('n', '<Leader>cc', '<Cmd>cc<CR>', { silent = true })
vim.keymap.set('n', '<Leader>ct', [[<Cmd>Qfilter!\V\<tests\?\>\C<CR>]], { silent = true })
vim.keymap.set('n', '<Leader>cT', [[<Cmd>Qfilter\V\<tests\?\>\C<CR>]], { silent = true })

-- Tab navigation mappings.
vim.keymap.set('n', '[t', '<Cmd>tabprevious<CR>', { silent = true })
vim.keymap.set('x', '[t', '<Cmd>tabprevious<CR>', { silent = true })

vim.keymap.set('n', '[T', '<Cmd>tabfirst<CR>', { silent = true })
vim.keymap.set('x', '[T', '<Cmd>tabfirst<CR>', { silent = true })

vim.keymap.set('n', ']t', '<Cmd>tabnext<CR>', { silent = true })
vim.keymap.set('x', ']t', '<Cmd>tabnext<CR>', { silent = true })

vim.keymap.set('n', ']T', '<Cmd>tablast<CR>', { silent = true })
vim.keymap.set('x', ']T', '<Cmd>tablast<CR>', { silent = true })

-- Copy current buffer path to the system clipboard.
vim.keymap.set('n', '<Leader>fa', function()
  copy_path.copy_file_path('absolute', 0, 0)
end, { silent = true })

vim.keymap.set('n', '<Leader>fr', function()
  copy_path.copy_file_path('relative', 0, 0)
end, { silent = true })

vim.keymap.set('n', '<Leader>fl', function()
  local line = vim.fn.line('.')
  copy_path.copy_file_path('relative', line, line)
end, { silent = true })

vim.keymap.set('x', '<Leader>fa', function()
  keymap_helpers.copy_visual_path_and_exit(copy_path, 'absolute')
end, { silent = true })

vim.keymap.set('x', '<Leader>fr', function()
  keymap_helpers.copy_visual_path_and_exit(copy_path, 'relative')
end, { silent = true })

vim.keymap.set('x', '<Leader>fl', function()
  keymap_helpers.copy_visual_path_and_exit(copy_path, 'relative')
end, { silent = true })

-- Set current word or visual selection as the current search term.
vim.keymap.set('n', 'gn', function()
  find_in_files.set_search_term_normal()
end, { silent = true })

vim.keymap.set('x', 'gn', function()
  find_in_files.set_search_term_visual()
  keymap_helpers.exit_visual_mode()
end, { silent = true })

-- Toggle highlighting of all occurrences of the current search term.
vim.keymap.set('n', 'gh', function()
  vim.opt.hlsearch = not vim.opt.hlsearch:get()
end, { silent = true })

vim.keymap.set('x', 'gh', function()
  vim.opt.hlsearch = not vim.opt.hlsearch:get()
end, { silent = true })

-- Find in files.
vim.keymap.set('n', '<F3>', function()
  find_in_files.find_in_files('')
end, { silent = true })

vim.keymap.set('n', '<S-F3>', function()
  find_in_files.find_in_files(find_in_files.set_search_term_normal(), true)
end, { silent = true })

vim.keymap.set('x', '<F3>', function()
  find_in_files.find_in_files(find_in_files.set_search_term_visual())
end, { silent = true })

vim.keymap.set('x', '<S-F3>', function()
  find_in_files.find_in_files(find_in_files.set_search_term_visual(), true)
end, { silent = true })

-- Double-tap to append a semicolon at end of line and continue inserting at prior insert position.
vim.keymap.set('i', ';;', '<C-g>u<Esc>A;<Esc>gi<C-g>u', { silent = true })

-- Double-tap to append a comma at end of line and continue inserting at prior insert position.
vim.keymap.set('i', ',,', '<C-g>u<Esc>A,<Esc>gi<C-g>u', { silent = true })

-- Save the current buffer.
vim.keymap.set('n', '<F5>', '<Cmd>write<CR>', { silent = true })

-- Leave insert mode and save the current buffer.
vim.keymap.set('i', '<F5>', '<Esc><Cmd>write<CR>', { silent = true })

-- Map jj to escape insert mode.
vim.keymap.set('i', 'jj', '<Esc>', { silent = true })

-- Map jj to leave terminal-job mode and enter terminal-normal mode.
vim.keymap.set('t', 'jj', '<C-\\><C-n>', { silent = true })

-- Redraw, reload file if changed on disk, resync syntax, and refresh ALE diagnostics.
vim.keymap.set('n', '<Leader>l', '<C-l><Cmd>checktime<CR><Cmd>syntax sync fromstart<CR><Cmd>ALELint<CR>', { silent = true })

-- In command-line mode, make <C-p>/<C-n> navigate completion menu or history.
vim.keymap.set('c', '<C-p>', function()
  if vim.fn.wildmenumode() == 1 then
    return '<C-p>'
  end

  return '<Up>'
end, { expr = true })

vim.keymap.set('c', '<C-n>', function()
  if vim.fn.wildmenumode() == 1 then
    return '<C-n>'
  end

  return '<Down>'
end, { expr = true })

-- Block quitting commands that would exit Neovim while terminal jobs are running.
vim.keymap.set('c', '<CR>', function()
  if vim.fn.getcmdtype() ~= ':' then
    return '<CR>'
  end

  local blocked, msg = terminal_quit_guard.should_block_cmdline(vim.fn.getcmdline())
  if blocked then
    vim.schedule(function()
      vim.notify(msg, vim.log.levels.WARN, { title = 'Terminal Quit Guard' })
    end)
    return '<C-c>'
  end

  return '<CR>'
end, { expr = true })

-- Use system clipboard for macOS Command-key cut/copy/paste.
vim.keymap.set('x', '<D-x>', '"+x', { silent = true })
vim.keymap.set('x', '<D-c>', '"+y', { silent = true })
vim.keymap.set('x', '<D-v>', '"+p', { silent = true })
vim.keymap.set('n', '<D-v>', '"+p', { silent = true })
vim.keymap.set('i', '<D-v>', '<C-r>+', { silent = true })
vim.keymap.set('c', '<D-v>', '<C-r>+', { silent = true })
vim.keymap.set('t', '<D-v>', function()
  vim.api.nvim_chan_send(vim.b.terminal_job_id, vim.fn.getreg('+'))
end, { silent = true })
