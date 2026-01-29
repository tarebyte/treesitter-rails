--- Query loading and caching module for treesitter-rails
--- @module treesitter-rails.queries

local M = {}

--- Cache for parsed queries per context
--- @type table<string, vim.treesitter.Query|false>
M.cache = {}

--- Get the plugin's root directory
--- @return string
local function get_plugin_root()
  -- Get the path of this file and navigate up to plugin root
  local source = debug.getinfo(1, 'S').source:sub(2)
  -- source is: .../lua/treesitter-rails/queries/init.lua
  -- we want: .../
  return vim.fn.fnamemodify(source, ':h:h:h:h')
end

--- Map of context names to their query file names
--- @type table<string, string>
M.query_files = {
  common = 'common.scm',
  model = 'model.scm',
  controller = 'controller.scm',
  view = 'view.scm',
  migration = 'migration.scm',
  routes = 'routes.scm',
  job = 'job.scm',
  mailer = 'mailer.scm',
  minitest = 'minitest.scm',
  rspec = 'rspec.scm',
}

--- Read a query file and return its contents
--- @param filename string The query file name
--- @return string|nil query_string The query string or nil
local function read_query_file(filename)
  local plugin_root = get_plugin_root()
  local query_path = plugin_root .. '/queries/' .. filename

  local file = io.open(query_path, 'r')
  if not file then
    return nil
  end

  local content = file:read('*a')
  file:close()
  return content
end

--- Get the query string for a context
--- @param context string The context name
--- @return string|nil query_string The query string or nil
function M.get_query_string(context)
  local filename = M.query_files[context]
  if not filename then
    return nil
  end

  return read_query_file(filename)
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

--- Get the parsed common query (applies to all Rails contexts)
--- @return vim.treesitter.Query|nil
function M.get_common()
  return M.get('common')
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

--- Reload all queries (useful during development)
function M.reload()
  M.clear_cache()
end

return M
