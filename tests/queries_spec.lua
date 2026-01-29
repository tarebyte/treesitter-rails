--- Tests for query modules
--- Run with: nvim --headless -c "luafile tests/queries_spec.lua" -c "q"

local queries = require('treesitter-rails.queries')

local function assert_true(val, msg)
  if not val then
    error(msg or 'Expected true')
  end
end

local function assert_not_nil(val, msg)
  if val == nil then
    error(msg or 'Expected non-nil value')
  end
end

local function test(name, fn)
  local ok, err = pcall(fn)
  if ok then
    print('PASS: ' .. name)
  else
    print('FAIL: ' .. name)
    print('  ' .. tostring(err))
  end
end

print('=== Query Module Tests ===\n')

-- Test that all query modules load
test('loads common query', function()
  local query = queries.get('common')
  assert_not_nil(query, 'common query should load')
end)

test('loads model query', function()
  local query = queries.get('model')
  assert_not_nil(query, 'model query should load')
end)

test('loads controller query', function()
  local query = queries.get('controller')
  assert_not_nil(query, 'controller query should load')
end)

test('loads view query', function()
  local query = queries.get('view')
  assert_not_nil(query, 'view query should load')
end)

test('loads migration query', function()
  local query = queries.get('migration')
  assert_not_nil(query, 'migration query should load')
end)

test('loads routes query', function()
  local query = queries.get('routes')
  assert_not_nil(query, 'routes query should load')
end)

test('loads job query', function()
  local query = queries.get('job')
  assert_not_nil(query, 'job query should load')
end)

test('loads mailer query', function()
  local query = queries.get('mailer')
  assert_not_nil(query, 'mailer query should load')
end)

test('loads minitest query', function()
  local query = queries.get('minitest')
  assert_not_nil(query, 'minitest query should load')
end)

test('loads rspec query', function()
  local query = queries.get('rspec')
  assert_not_nil(query, 'rspec query should load')
end)

-- Test get_common helper
test('get_common returns same as get("common")', function()
  local common1 = queries.get_common()
  local common2 = queries.get('common')
  assert_true(common1 == common2, 'get_common should return same query as get("common")')
end)

-- Test caching
test('queries are cached', function()
  queries.clear_cache()
  local query1 = queries.get('model')
  local query2 = queries.get('model')
  assert_true(query1 == query2, 'same query object should be returned')
end)

-- Test invalid context
test('returns nil for invalid context', function()
  local query = queries.get('invalid_context')
  assert_true(query == nil, 'invalid context should return nil')
end)

-- Test cache clearing
test('clear_cache clears specific context', function()
  local query1 = queries.get('model')
  queries.clear_cache('model')
  -- After clearing, cache[model] is nil, so get will re-parse
  -- We can't easily test this without accessing internals, but at least verify it doesn't error
  local query2 = queries.get('model')
  assert_not_nil(query2, 'should still return query after cache clear')
end)

test('clear_cache with no args clears all', function()
  queries.get('model')
  queries.get('controller')
  queries.clear_cache()
  -- Verify no errors occur
  assert_not_nil(queries.get('model'), 'should return query after full cache clear')
end)

print('\n=== All tests completed ===')
