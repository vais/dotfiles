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
-- Editing
-- ============================================================================

-- Use smart auto-indenting when starting a new line.
vim.opt.smartindent = true

-- Allow virtual editing in visual block mode.
vim.opt.virtualedit = 'block'

-- ============================================================================
-- Grep
-- ============================================================================

-- Read grep patterns from ~/.vimsearch, one per line.
vim.opt.grepprg = 'git grep -f "' .. vim.fn.expand('~/.vimsearch') .. '"'

-- Do not match patterns in binary files.
vim.opt.grepprg:append(' -I')

-- Prefix grep matches with line numbers.
vim.opt.grepprg:append(' -n')

-- Parse grep output with or without an explicit column number.
vim.opt.grepformat = '%f:%l:%c:%m,%f:%l:%m'

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
-- Shell and terminal
-- ============================================================================

-- Use non-login Bash for external command execution to keep ALE/Fugitive/GV fast.
vim.opt.shell = '/bin/bash'

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
-- Folding
-- ============================================================================

-- Start with folds effectively open.
vim.opt.foldlevelstart = 99

-- Build folds from indentation levels.
vim.opt.foldmethod = 'indent'

-- ============================================================================
-- Input and mouse
-- ============================================================================

-- Enable mouse support in all modes.
vim.opt.mouse = 'a'

-- Scroll one line per vertical mouse wheel/trackpad tick.
vim.opt.mousescroll = 'ver:1,hor:1'

-- Enable smooth scrolling behavior.
vim.opt.smoothscroll = true

-- Trigger CursorHold/swapfile and plugin idle updates quickly, especially for GitGutter refresh.
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
