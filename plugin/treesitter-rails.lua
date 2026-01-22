-- treesitter-rails plugin entry point
-- Auto-initialization and user commands

if vim.g.loaded_treesitter_rails then
  return
end
vim.g.loaded_treesitter_rails = true

-- Check Neovim version
if vim.fn.has('nvim-0.9') ~= 1 then
  vim.notify('[treesitter-rails] Requires Neovim 0.9 or higher', vim.log.levels.ERROR)
  return
end

-- User commands
vim.api.nvim_create_user_command('TreesitterRailsEnable', function()
  require('treesitter-rails').enable()
end, { desc = 'Enable treesitter-rails highlighting' })

vim.api.nvim_create_user_command('TreesitterRailsDisable', function()
  require('treesitter-rails').disable()
end, { desc = 'Disable treesitter-rails highlighting' })

vim.api.nvim_create_user_command('TreesitterRailsToggle', function()
  require('treesitter-rails').toggle()
end, { desc = 'Toggle treesitter-rails highlighting' })

vim.api.nvim_create_user_command('TreesitterRailsRefresh', function()
  require('treesitter-rails').refresh()
end, { desc = 'Refresh treesitter-rails highlighting' })

vim.api.nvim_create_user_command('TreesitterRailsInfo', function()
  require('treesitter-rails').info()
end, { desc = 'Show treesitter-rails status info' })

vim.api.nvim_create_user_command('TreesitterRailsContext', function()
  local context = require('treesitter-rails').get_context()
  if context then
    print('Context: ' .. context)
  else
    print('No Rails context detected')
  end
end, { desc = 'Show detected Rails context for current buffer' })

vim.api.nvim_create_user_command('TreesitterRailsReload', function()
  require('treesitter-rails').reload()
  print('treesitter-rails queries reloaded')
end, { desc = 'Reload treesitter-rails queries (for development)' })
