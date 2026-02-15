local M = {}

function M.setup()
  -- Do not force cursor recentering while AutoPairs inserts pairs.
  vim.g.AutoPairsCenterLine = 0

  -- Disable fly mode to avoid extra jump behavior while typing.
  vim.g.AutoPairsFlyMode = 0

  -- Disable AutoPairs toggle shortcut.
  vim.g.AutoPairShortcutToggle = ''

  -- Disable AutoPairs fast-wrap shortcut.
  vim.g.AutoPairsShortcutFastWrap = ''

  -- Disable AutoPairs jump shortcut.
  vim.g.AutoPairsShortcutJump = ''

  -- Disable AutoPairs back-insert shortcut.
  vim.g.AutoPairsShortcutBackInsert = ''
end

return M
