local M = {}

function M.setup()
  -- Keep custom next/last mappings for targets.vim newline text object.
  if vim.g.targets_nl == nil then
    vim.g.targets_nl = 'nN'
  end

  local group = vim.api.nvim_create_augroup('ConfigureTargetsPlugin', { clear = true })

  -- Extend targets.vim mappings after plugin user mappings are initialized.
  vim.api.nvim_create_autocmd('User', {
    group = group,
    pattern = 'targets#mappings#user',
    callback = function()
      vim.fn['targets#mappings#extend']({
        a = {
          argument = {
            {
              o = '[{([]',
              c = '[])}]',
              s = ',',
            },
          },
        },
        b = {
          pair = {
            {
              o = '(',
              c = ')',
            },
          },
        },
      })
    end,
  })
end

return M
