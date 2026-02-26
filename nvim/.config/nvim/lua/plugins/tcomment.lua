local M = {}

function M.setup()
  -- tcomment maps are defined during plugin startup; add the bridge after
  -- startup so it is guaranteed to win.
  vim.api.nvim_create_autocmd('VimEnter', {
    once = true,
    callback = function()
      -- Reliable bridge for comment-operator + flash in one sequence.
      -- This avoids edge-cases with custom g@ operator mappings.
      vim.keymap.set('n', 'gc<Leader>j', function()
        vim.fn['tcomment#ResetOption']()
        if vim.v.count > 0 then
          vim.fn['tcomment#SetOption']('count', vim.v.count)
        end
        vim.w.tcommentPos = vim.fn.getpos('.')
        vim.go.operatorfunc = 'TCommentOpFunc_gc'

        local keys = vim.api.nvim_replace_termcodes('g@<Leader>j', true, false, true)
        vim.api.nvim_feedkeys(keys, 'm', false)
      end, { silent = true })
    end,
  })
end

return M
