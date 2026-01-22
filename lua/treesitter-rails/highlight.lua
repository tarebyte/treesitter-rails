--- Highlight module for treesitter-rails
--- Implements decoration provider for context-aware highlighting
--- @module treesitter-rails.highlight

local M = {}

local context = require('treesitter-rails.context')
local queries = require('treesitter-rails.queries')
local config = require('treesitter-rails.config')

--- Namespace for treesitter-rails extmarks
--- @type number
M.namespace = vim.api.nvim_create_namespace('treesitter-rails')

--- Buffers that have been attached
--- @type table<number, boolean>
M.attached_buffers = {}

--- Check if buffer has a Ruby tree-sitter parser
--- @param bufnr number Buffer number
--- @return boolean
local function has_ruby_parser(bufnr)
  local ok, parser = pcall(vim.treesitter.get_parser, bufnr, 'ruby')
  return ok and parser ~= nil
end

--- Get the tree for a buffer
--- @param bufnr number Buffer number
--- @return TSTree|nil
local function get_tree(bufnr)
  local ok, parser = pcall(vim.treesitter.get_parser, bufnr, 'ruby')
  if not ok or not parser then
    return nil
  end

  local trees = parser:trees()
  return trees and trees[1] or nil
end

--- Apply highlights for a range in a buffer
--- @param bufnr number Buffer number
--- @param ctx string Context name
--- @param start_row number Start row (0-indexed)
--- @param end_row number End row (0-indexed)
local function apply_highlights(bufnr, ctx, start_row, end_row)
  local query = queries.get(ctx)
  if not query then
    return
  end

  local tree = get_tree(bufnr)
  if not tree then
    return
  end

  local root = tree:root()
  local priority = config.options.priority

  -- Iterate over matches in the visible range
  for id, node, metadata in query:iter_captures(root, bufnr, start_row, end_row + 1) do
    local name = query.captures[id]
    local range = { node:range() }

    -- Only process captures that start with our prefixes
    if name:match('^function%.') or name:match('^keyword%.') or name:match('^variable%.') then
      local hl_group = '@' .. name .. '.ruby'

      vim.api.nvim_buf_set_extmark(bufnr, M.namespace, range[1], range[2], {
        end_row = range[3],
        end_col = range[4],
        hl_group = hl_group,
        priority = priority,
        ephemeral = true,
      })
    end
  end
end

--- Decoration provider callbacks
--- @type table
M.provider = {
  on_start = function(_, tick)
    return config.options.enabled
  end,

  on_buf = function(_, bufnr, tick)
    -- Only process attached buffers
    return M.attached_buffers[bufnr] == true
  end,

  on_win = function(_, winid, bufnr, toprow, botrow)
    if not M.attached_buffers[bufnr] then
      return false
    end

    local ctx = context.get_buffer_context(bufnr)
    if not ctx then
      return false
    end

    -- Check if this context is enabled
    local contexts = config.options.contexts
    if contexts and not vim.tbl_contains(contexts, ctx) then
      return false
    end

    -- Apply highlights for visible range
    apply_highlights(bufnr, ctx, toprow, botrow)

    return false -- Don't call on_line
  end,
}

--- Attach highlighting to a buffer
--- @param bufnr number Buffer number
--- @return boolean success Whether attachment was successful
function M.attach(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  -- Already attached
  if M.attached_buffers[bufnr] then
    return true
  end

  -- Check if buffer is valid Ruby file
  if vim.bo[bufnr].filetype ~= 'ruby' then
    return false
  end

  -- Check if Ruby parser is available
  if not has_ruby_parser(bufnr) then
    return false
  end

  -- Detect context
  local ctx = context.get_buffer_context(bufnr)
  if not ctx then
    -- Still attach - context might change or file might be moved
    M.attached_buffers[bufnr] = true
    return true
  end

  -- Check if this context is enabled
  local contexts = config.options.contexts
  if contexts and not vim.tbl_contains(contexts, ctx) then
    return false
  end

  M.attached_buffers[bufnr] = true

  -- Setup buffer autocommands for cleanup
  vim.api.nvim_create_autocmd('BufDelete', {
    buffer = bufnr,
    once = true,
    callback = function()
      M.detach(bufnr)
    end,
  })

  -- Clear cache on file rename (context might change)
  vim.api.nvim_create_autocmd('BufFilePost', {
    buffer = bufnr,
    callback = function()
      context.clear_cache(bufnr)
    end,
  })

  return true
end

--- Detach highlighting from a buffer
--- @param bufnr number Buffer number
function M.detach(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  M.attached_buffers[bufnr] = nil
  context.clear_cache(bufnr)

  -- Clear any existing extmarks
  if vim.api.nvim_buf_is_valid(bufnr) then
    vim.api.nvim_buf_clear_namespace(bufnr, M.namespace, 0, -1)
  end
end

--- Check if a buffer is attached
--- @param bufnr number Buffer number
--- @return boolean
function M.is_attached(bufnr)
  return M.attached_buffers[bufnr] == true
end

--- Enable the decoration provider
function M.enable()
  vim.api.nvim_set_decoration_provider(M.namespace, M.provider)
end

--- Disable the decoration provider
function M.disable()
  vim.api.nvim_set_decoration_provider(M.namespace, {})

  -- Clear all extmarks in attached buffers
  for bufnr, _ in pairs(M.attached_buffers) do
    if vim.api.nvim_buf_is_valid(bufnr) then
      vim.api.nvim_buf_clear_namespace(bufnr, M.namespace, 0, -1)
    end
  end
end

--- Refresh highlighting for a buffer
--- @param bufnr number|nil Buffer number (nil for current)
function M.refresh(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  if M.attached_buffers[bufnr] then
    -- Clear extmarks
    vim.api.nvim_buf_clear_namespace(bufnr, M.namespace, 0, -1)

    -- Force redraw
    vim.cmd('redraw')
  end
end

return M
