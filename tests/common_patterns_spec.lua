--- Tests for common query patterns
--- Verifies that common.scm doesn't include standard Ruby patterns
--- Run with: nvim --headless -c "luafile tests/common_patterns_spec.lua" -c "q"

local function test(name, fn)
  local ok, err = pcall(fn)
  if ok then
    print('PASS: ' .. name)
  else
    print('FAIL: ' .. name)
    print('  ' .. tostring(err))
  end
end

local function assert_not_contains(str, pattern, msg)
  if str:find(pattern, 1, true) then
    error(msg or string.format('String should not contain %q', pattern))
  end
end

local function assert_contains(str, pattern, msg)
  if not str:find(pattern, 1, true) then
    error(msg or string.format('String should contain %q', pattern))
  end
end

print('=== Common Query Pattern Tests ===\n')

local queries = require('treesitter-rails.queries')
local query_string = queries.get_query_string('common')

-- Verify standard Ruby patterns are NOT included
print('-- Patterns that should NOT be in common.scm --\n')

test('does not include generic "include"', function()
  -- Check it doesn't have a simple include pattern (without ActiveSupport::Concern context)
  -- The query should not match: ((call method: (identifier) @x (#eq? @x "include")))
  -- But it's tricky because we do want "include" in specific contexts
  -- For now, just verify we don't have the simple any-of pattern with include
  local simple_include = '"include"\n    "extend"\n    "prepend"'
  assert_not_contains(query_string, simple_include, 'should not have simple include/extend/prepend pattern')
end)

test('does not include generic "autoload"', function()
  assert_not_contains(query_string, '"autoload"', 'should not include autoload')
end)

test('does not include "eager_autoload"', function()
  assert_not_contains(query_string, '"eager_autoload"', 'should not include eager_autoload')
end)

-- Verify Rails-specific patterns ARE included
print('\n-- Patterns that SHOULD be in common.scm --\n')

test('includes delegate', function()
  assert_contains(query_string, '"delegate"', 'should include delegate')
end)

test('includes delegate_missing_to', function()
  assert_contains(query_string, '"delegate_missing_to"', 'should include delegate_missing_to')
end)

test('includes class_attribute', function()
  assert_contains(query_string, '"class_attribute"', 'should include class_attribute')
end)

test('includes cattr_accessor', function()
  assert_contains(query_string, '"cattr_accessor"', 'should include cattr_accessor')
end)

test('includes mattr_accessor', function()
  assert_contains(query_string, '"mattr_accessor"', 'should include mattr_accessor')
end)

test('includes with_options', function()
  assert_contains(query_string, '"with_options"', 'should include with_options')
end)

test('includes included (Concern DSL)', function()
  assert_contains(query_string, '"included"', 'should include included')
end)

test('includes class_methods (Concern DSL)', function()
  assert_contains(query_string, '"class_methods"', 'should include class_methods')
end)

test('includes ActiveSupport::Concern extend pattern', function()
  assert_contains(query_string, 'ActiveSupport', 'should include ActiveSupport::Concern pattern')
  assert_contains(query_string, 'Concern', 'should include ActiveSupport::Concern pattern')
end)

test('includes time helpers (day, days)', function()
  assert_contains(query_string, '"day"', 'should include time helpers')
  assert_contains(query_string, '"days"', 'should include time helpers')
end)

test('includes time helpers (ago, from_now)', function()
  assert_contains(query_string, '"ago"', 'should include ago')
  assert_contains(query_string, '"from_now"', 'should include from_now')
end)

test('includes byte helpers', function()
  assert_contains(query_string, '"megabyte"', 'should include byte helpers')
  assert_contains(query_string, '"gigabyte"', 'should include byte helpers')
end)

test('includes Rails.env helpers', function()
  assert_contains(query_string, '"development?"', 'should include Rails.env helpers')
  assert_contains(query_string, '"production?"', 'should include Rails.env helpers')
end)

test('includes Rails.logger helpers', function()
  assert_contains(query_string, 'logger', 'should include Rails.logger pattern')
end)

test('includes Rails.cache helpers', function()
  assert_contains(query_string, 'cache', 'should include Rails.cache pattern')
end)

test('includes deprecation helpers', function()
  assert_contains(query_string, '"deprecate"', 'should include deprecate')
end)

test('includes callback helpers', function()
  assert_contains(query_string, '"define_callbacks"', 'should include define_callbacks')
  assert_contains(query_string, '"set_callback"', 'should include set_callback')
end)

print('\n=== All tests completed ===')
