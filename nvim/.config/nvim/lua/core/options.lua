-- ============================================================================
-- Appearance and UI
-- ============================================================================

-- In :terminal job-mode, use a non-blinking vertical bar cursor.
vim.opt.guicursor = vim.go.guicursor .. ',t:ver25-blinkon0'

-- Show absolute line numbers.
vim.opt.number = true

-- Use legacy custom statusline format.
vim.opt.statusline = [[[%n] %<%.999f %h%w%1*%m%*%#error#%r%*]]

-- Enable 24-bit RGB colors in supported terminals.
vim.opt.termguicolors = true

-- Disable line wrapping.
vim.opt.wrap = false

-- When wrapping is enabled, wrap at breakat characters.
vim.opt.linebreak = true

-- ============================================================================
-- Completion
-- ============================================================================

-- Restrict completion sources to current buffer and listed buffers/windows.
vim.opt.complete = '.,w,b'

-- Configure popup completion to not preselect or preinsert.
vim.opt.completeopt = 'menuone,noselect,noinsert'

-- Complete files like a shell with list-first behavior.
vim.opt.wildmode = 'list:longest'

-- ============================================================================
-- Editing and Structure
-- ============================================================================

-- Use smart auto-indenting when starting a new line.
vim.opt.smartindent = true

-- Allow virtual editing in visual block mode.
vim.opt.virtualedit = 'block'

-- Start with folds effectively open.
vim.opt.foldlevelstart = 99

-- Build folds from indentation levels.
vim.opt.foldmethod = 'indent'

_G.dotfiles_foldtext = function()
  local fold_text = vim.fn.foldtext()
  local indent, prefix, spacing = fold_text:match('^(%s*)([%+%-][%+%-]+)(%s*)')
  if not prefix then
    return fold_text
  end

  local marker = string.rep('·', #prefix)
  local rest = fold_text:sub(#indent + #prefix + #spacing + 1)
  return indent .. marker .. ' ' .. rest
end
vim.opt.foldtext = 'v:lua.dotfiles_foldtext()'

-- ============================================================================
-- Indentation and tabs
-- ============================================================================

-- Insert spaces when pressing Tab.
vim.opt.expandtab = true

-- Round indent shifts to multiples of shiftwidth.
vim.opt.shiftround = true

-- Number of spaces used for each indent step.
vim.opt.shiftwidth = 2

-- Number of spaces a Tab counts for while editing.
vim.opt.softtabstop = 2

-- Display width of a hard tab character.
vim.opt.tabstop = 2

-- ============================================================================
-- Files and I/O
-- ============================================================================

-- Keep legacy fileformat handling order for mixed Unix/DOS/Mac files.
vim.opt.fileformats = 'unix,dos,mac'

-- Disable swap files.
vim.opt.swapfile = false

-- Disable write-backup files when overwriting.
vim.opt.writebackup = false

-- ============================================================================
-- Search
-- ============================================================================

-- Do not persistently highlight all search matches.
vim.opt.hlsearch = false

-- Use case-insensitive search by default.
vim.opt.ignorecase = true

-- Make search case-sensitive if the pattern contains uppercase.
vim.opt.smartcase = true

-- ============================================================================
-- Sessions
-- ============================================================================

-- Do not persist empty helper windows into sessions.
vim.opt.sessionoptions:remove('blank')

-- Do not persist options/mappings into sessions.
vim.opt.sessionoptions:remove('options')

-- ============================================================================
-- Shell and External Commands
-- ============================================================================

-- Use non-login Bash for external command execution to keep tooling responsive.
vim.opt.shell = '/bin/bash'

-- ============================================================================
-- Terminal and Window Title
-- ============================================================================

-- Let Neovim control the terminal title and show the current working directory.
vim.opt.title = true
vim.opt.titlestring = "%{fnamemodify(getcwd(),':~')}"

-- ============================================================================
-- Startup behavior
-- ============================================================================

-- Disable modelines for security and predictability.
vim.opt.modelines = 0

-- Suppress the startup intro message.
vim.opt.shortmess:append('I')

-- ============================================================================
-- Input and mouse
-- ============================================================================

-- Enable mouse support in all modes.
vim.opt.mouse = 'a'

-- Scroll one line per vertical mouse wheel/trackpad tick.
vim.opt.mousescroll = 'ver:1,hor:1'

-- Enable smooth scrolling behavior.
vim.opt.smoothscroll = true

-- Trigger CursorHold/swapfile and plugin idle updates quickly,
-- especially for GitGutter refresh.
vim.opt.updatetime = 100

-- ============================================================================
-- Windows and splits
-- ============================================================================

-- Keep existing window sizes when splitting/closing.
vim.opt.equalalways = false

-- Open horizontal splits below the current window.
vim.opt.splitbelow = true

-- Open vertical splits to the right of the current window.
vim.opt.splitright = true
