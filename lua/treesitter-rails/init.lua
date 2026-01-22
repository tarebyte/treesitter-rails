--- treesitter-rails: Rails-specific Tree-sitter syntax highlighting
--- @module treesitter-rails

local M = {}

local config = require('treesitter-rails.config')
local highlight = require('treesitter-rails.highlight')
local context = require('treesitter-rails.context')

--- Plugin version
M.version = '0.1.0'

--- Whether the plugin has been setup
--- @type boolean
M._setup_done = false

--- Setup the plugin with user options
--- @param opts table|nil Configuration options
--- @field enabled boolean Enable the plugin (default: true)
--- @field priority number Highlight priority (default: 125)
--- @field contexts string[]|nil Contexts to enable (nil means all)
function M.setup(opts)
  -- Apply configuration
  config.setup(opts)

  -- Enable decoration provider
  if config.options.enabled then
    highlight.enable()
  end

  -- Setup autocommand to attach to Ruby buffers
  local group = vim.api.nvim_create_augroup('treesitter-rails', { clear = true })

  vim.api.nvim_create_autocmd('FileType', {
    group = group,
    pattern = 'ruby',
    callback = function(args)
      if config.options.enabled then
        highlight.attach(args.buf)
      end
    end,
    desc = 'Attach treesitter-rails highlighting to Ruby buffers',
  })

  -- Attach to already open Ruby buffers
  if config.options.enabled then
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].filetype == 'ruby' then
        highlight.attach(bufnr)
      end
    end
  end

  M._setup_done = true
end

--- Enable the plugin
function M.enable()
  config.options.enabled = true
  highlight.enable()

  -- Attach to all Ruby buffers
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].filetype == 'ruby' then
      highlight.attach(bufnr)
    end
  end
end

--- Disable the plugin
function M.disable()
  config.options.enabled = false
  highlight.disable()
end

--- Toggle the plugin on/off
function M.toggle()
  if config.options.enabled then
    M.disable()
  else
    M.enable()
  end
end

--- Check if the plugin is enabled
--- @return boolean
function M.is_enabled()
  return config.options.enabled
end

--- Refresh highlighting for the current buffer
function M.refresh()
  highlight.refresh()
end

--- Get the detected context for a buffer
--- @param bufnr number|nil Buffer number (nil for current)
--- @return string|nil context The detected context
function M.get_context(bufnr)
  return context.get_buffer_context(bufnr)
end

--- Manually set context for a buffer (for debugging)
--- @param bufnr number Buffer number
--- @param ctx string Context name
function M.set_context(bufnr, ctx)
  if context.is_valid(ctx) then
    context.cache[bufnr] = ctx
    highlight.refresh(bufnr)
  else
    vim.notify(
      string.format('[treesitter-rails] Invalid context: %s', ctx),
      vim.log.levels.WARN
    )
  end
end

--- Get available contexts
--- @return string[]
function M.contexts()
  return vim.deepcopy(context.contexts)
end

--- Reload all queries (useful for development)
function M.reload()
  local queries = require('treesitter-rails.queries')
  queries.reload()

  -- Refresh all attached buffers
  for bufnr, _ in pairs(highlight.attached_buffers) do
    highlight.refresh(bufnr)
  end
end

--- Get plugin status info
--- @return table
function M.status()
  local attached = {}
  for bufnr, _ in pairs(highlight.attached_buffers) do
    if vim.api.nvim_buf_is_valid(bufnr) then
      local name = vim.api.nvim_buf_get_name(bufnr)
      local ctx = context.get_buffer_context(bufnr)
      table.insert(attached, {
        bufnr = bufnr,
        name = vim.fn.fnamemodify(name, ':~:.'),
        context = ctx,
      })
    end
  end

  return {
    enabled = config.options.enabled,
    priority = config.options.priority,
    contexts = config.options.contexts,
    attached_buffers = attached,
  }
end

--- Print plugin status
function M.info()
  local status = M.status()

  print('treesitter-rails v' .. M.version)
  print('  Enabled: ' .. tostring(status.enabled))
  print('  Priority: ' .. status.priority)
  print('  Contexts: ' .. (status.contexts and table.concat(status.contexts, ', ') or 'all'))
  print('  Attached buffers: ' .. #status.attached_buffers)

  for _, buf in ipairs(status.attached_buffers) do
    print(string.format('    [%d] %s (%s)', buf.bufnr, buf.name, buf.context or 'no context'))
  end
end

return M
