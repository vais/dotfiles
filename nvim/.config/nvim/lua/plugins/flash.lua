local M = {}

function M.setup()
  require('flash').setup({
    label = {
      uppercase = false,
    },
    modes = {
      char = {
        enabled = false,
      },
    },
  })

  vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>j', function()
    local opts = {
      search = {
        multi_window = true,
      },
      actions = {
        ['mode_line'] = function(state)
          state.pattern.mode = 'search'
          state.opts.search.mode = 'search'
          state.opts.search.max_length = 0
          state.opts.label.after = { 0, 0 }
          state.opts.label.uppercase = true
          state:update({ pattern = '^' })
          return true
        end,
        ['<CR>'] = function(state)
          if state.pattern:empty() then
            return state.opts.actions.mode_line(state)
          end
          state:jump()
          return false
        end,
      },
    }

    local state = require('flash.repeat').get_state('jump', opts)
    state:loop({
      abort = function()
        if vim.v.operator == 'g@' and vim.go.operatorfunc == 'TCommentOpFunc_gc' then
          vim.go.operatorfunc = [[{x -> x}]]
          vim.w.tcommentPos = nil
          pcall(vim.fn['tcomment#ResetOption'])
        end
      end,
    })
  end, { silent = true })
end

return M
