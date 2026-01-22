--- Query loading and caching module for treesitter-rails
--- @module treesitter-rails.queries

local M = {}

--- Cache for parsed queries per context
--- @type table<string, vim.treesitter.Query|false>
M.cache = {}

--- Map of context names to their query module names
--- @type table<string, string>
M.query_modules = {
  model = 'treesitter-rails.queries.model',
  controller = 'treesitter-rails.queries.controller',
  view = 'treesitter-rails.queries.view',
  migration = 'treesitter-rails.queries.migration',
  routes = 'treesitter-rails.queries.routes',
  job = 'treesitter-rails.queries.job',
  mailer = 'treesitter-rails.queries.mailer',
  minitest = 'treesitter-rails.queries.test',
  rspec = 'treesitter-rails.queries.test',
}

--- Get the query string for a context
--- @param context string The context name
--- @return string|nil query_string The query string or nil
function M.get_query_string(context)
  local module_name = M.query_modules[context]
  if not module_name then
    return nil
  end

  local ok, query_module = pcall(require, module_name)
  if not ok or not query_module then
    return nil
  end

  -- For test contexts, get the appropriate variant
  if context == 'minitest' and query_module.minitest then
    return query_module.minitest
  elseif context == 'rspec' and query_module.rspec then
    return query_module.rspec
  end

  return query_module.query
end

--- Get a parsed query for a context
--- @param context string The context name
--- @return vim.treesitter.Query|nil query The parsed query or nil
function M.get(context)
  -- Check cache first
  if M.cache[context] ~= nil then
    return M.cache[context] or nil
  end

  local query_string = M.get_query_string(context)
  if not query_string then
    M.cache[context] = false
    return nil
  end

  local ok, query = pcall(vim.treesitter.query.parse, 'ruby', query_string)
  if not ok or not query then
    vim.notify(
      string.format('[treesitter-rails] Failed to parse query for context: %s', context),
      vim.log.levels.WARN
    )
    M.cache[context] = false
    return nil
  end

  M.cache[context] = query
  return query
end

--- Clear the query cache
--- @param context string|nil Context to clear (nil clears all)
function M.clear_cache(context)
  if context then
    M.cache[context] = nil
  else
    M.cache = {}
  end
end

--- Reload all query modules (useful during development)
function M.reload()
  M.clear_cache()
  for _, module_name in pairs(M.query_modules) do
    package.loaded[module_name] = nil
  end
end

return M
