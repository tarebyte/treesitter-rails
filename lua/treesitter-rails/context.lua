--- Context detection module for treesitter-rails
--- Determines the Rails context from file paths
--- @module treesitter-rails.context

local M = {}

--- Context patterns mapping file paths to contexts
--- Order matters: more specific patterns should come first
--- @type table<string, string>
M.patterns = {
  -- Models (including concerns)
  { pattern = 'app/models/concerns/', context = 'model' },
  { pattern = 'app/models/', context = 'model' },

  -- Controllers (including concerns)
  { pattern = 'app/controllers/concerns/', context = 'controller' },
  { pattern = 'app/controllers/', context = 'controller' },

  -- Views and helpers
  { pattern = 'app/views/', context = 'view' },
  { pattern = 'app/helpers/', context = 'view' },

  -- Jobs
  { pattern = 'app/jobs/', context = 'job' },

  -- Mailers
  { pattern = 'app/mailers/', context = 'mailer' },

  -- Migrations and schema
  { pattern = 'db/migrate/', context = 'migration' },
  { pattern = 'db/schema.rb', context = 'migration' },
  { pattern = 'db/structure.sql', context = 'migration' },

  -- Routes
  { pattern = 'config/routes.rb', context = 'routes' },
  { pattern = 'config/routes/', context = 'routes' },

  -- RSpec tests
  { pattern = 'spec/models/', context = 'rspec' },
  { pattern = 'spec/controllers/', context = 'rspec' },
  { pattern = 'spec/requests/', context = 'rspec' },
  { pattern = 'spec/features/', context = 'rspec' },
  { pattern = 'spec/system/', context = 'rspec' },
  { pattern = 'spec/jobs/', context = 'rspec' },
  { pattern = 'spec/mailers/', context = 'rspec' },
  { pattern = 'spec/helpers/', context = 'rspec' },
  { pattern = 'spec/views/', context = 'rspec' },
  { pattern = 'spec/routing/', context = 'rspec' },
  { pattern = 'spec/', context = 'rspec' },

  -- Minitest tests
  { pattern = 'test/models/', context = 'minitest' },
  { pattern = 'test/controllers/', context = 'minitest' },
  { pattern = 'test/integration/', context = 'minitest' },
  { pattern = 'test/system/', context = 'minitest' },
  { pattern = 'test/jobs/', context = 'minitest' },
  { pattern = 'test/mailers/', context = 'minitest' },
  { pattern = 'test/helpers/', context = 'minitest' },
  { pattern = 'test/', context = 'minitest' },
}

--- Cache for detected contexts per buffer
--- @type table<number, string|nil>
M.cache = {}

--- Detect Rails context from a file path
--- @param filepath string The file path to analyze
--- @return string|nil context The detected context or nil
function M.detect(filepath)
  if not filepath or filepath == '' then
    return nil
  end

  -- Normalize path separators for cross-platform compatibility
  filepath = filepath:gsub('\\', '/')

  -- Check each pattern in order
  for _, entry in ipairs(M.patterns) do
    if filepath:find(entry.pattern, 1, true) then
      return entry.context
    end
  end

  return nil
end

--- Get context for a buffer (with caching)
--- @param bufnr number Buffer number
--- @return string|nil context The detected context or nil
function M.get_buffer_context(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  -- Check cache first
  if M.cache[bufnr] ~= nil then
    return M.cache[bufnr]
  end

  -- Get buffer file path
  local filepath = vim.api.nvim_buf_get_name(bufnr)
  local context = M.detect(filepath)

  -- Cache the result (even if nil)
  M.cache[bufnr] = context or false

  return context
end

--- Clear context cache for a buffer
--- @param bufnr number|nil Buffer number (nil clears all)
function M.clear_cache(bufnr)
  if bufnr then
    M.cache[bufnr] = nil
  else
    M.cache = {}
  end
end

--- List of all valid contexts
--- @type string[]
M.contexts = {
  'model',
  'controller',
  'view',
  'job',
  'mailer',
  'migration',
  'routes',
  'minitest',
  'rspec',
}

--- Check if a context is valid
--- @param context string The context to check
--- @return boolean
function M.is_valid(context)
  return vim.tbl_contains(M.contexts, context)
end

return M
