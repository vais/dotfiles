local M = {}

function M.setup()
  local toggleterm = require('toggleterm')
  local terminals = require('toggleterm.terminal')
  local ai_term = require('features.ai_term')
  local term_label = require('features.toggleterm_label')
  local opts = { silent = true }
  local function get_float_terminals()
    local all = terminals.get_all(false)
    return vim.tbl_filter(function(term)
      return term.direction == 'float'
    end, all)
  end

  local function focus_or_open(term)
    if term:is_open() then
      term:focus()
    else
      term:open()
    end
  end

  local function cycle_terminal(delta)
    local all = get_float_terminals()
    if #all == 0 then
      return
    end

    local current_id, current_term = terminals.identify()
    local current_idx

    if current_id and current_term and current_term.direction == 'float' then
      for idx, term in ipairs(all) do
        if term.id == current_id then
          current_idx = idx
          break
        end
      end
    end

    if not current_idx then
      local last_focused = terminals.get_last_focused()
      if last_focused and last_focused.direction == 'float' then
        for idx, term in ipairs(all) do
          if term.id == last_focused.id then
            current_idx = idx
            break
          end
        end
      end
    end

    if not current_idx then
      focus_or_open(all[1])
      return
    end

    local target_idx = ((current_idx - 1 + delta) % #all) + 1
    focus_or_open(all[target_idx])
  end

  toggleterm.setup({
    -- Use a login shell in ToggleTerm so interactive terminals get full env setup.
    shell = '/bin/bash -l',
    direction = 'float',
    on_open = function(term)
      term_label.apply(term)
      if term.direction == 'float' then
        -- Keep file-jump mappings from triggering in float terminal buffers.
        vim.keymap.set({ 'n', 'x' }, 'gf', '<Nop>', { buffer = term.bufnr, silent = true })
        vim.keymap.set({ 'n', 'x' }, 'gF', '<Nop>', { buffer = term.bufnr, silent = true })
        vim.keymap.set({ 'n', 'x' }, '<C-w>f', '<Cmd>vertical wincmd f<CR>', { buffer = term.bufnr, silent = true })
        vim.keymap.set({ 'n', 'x' }, '<C-w>F', '<Cmd>vertical wincmd F<CR>', { buffer = term.bufnr, silent = true })
      end
    end,
    on_close = function(term)
      if term.direction == 'float' then
        vim.g.fugitive_reload_after_toggleterm = true
      end
    end,
    on_exit = function(term)
      term_label.clear(term)
    end,
    float_opts = {
      border = 'rounded',
    },
  })

  ai_term.setup()

  -- Toggle terminal from normal mode.
  vim.keymap.set('n', '<C-Space>', function()
    ai_term.capture_current_location()
    toggleterm.toggle()
  end, opts)

  -- Toggle terminal from visual mode and record the selected line range for manual <C-.> send.
  vim.keymap.set('x', '<C-Space>', function()
    ai_term.capture_visual_selection()
    toggleterm.toggle()
  end, opts)

  -- Toggle terminal from terminal mode.
  vim.keymap.set('t', '<C-Space>', toggleterm.toggle, opts)

  -- Cycle existing float terminals from normal and terminal modes.
  vim.keymap.set({ 'n', 't' }, '<C-9>', function()
    cycle_terminal(-1)
  end, opts)
  vim.keymap.set({ 'n', 't' }, '<C-0>', function()
    cycle_terminal(1)
  end, opts)
end

return M
