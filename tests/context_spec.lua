--- Tests for context detection
--- Run with: nvim --headless -c "luafile tests/context_spec.lua" -c "q"

local context = require('treesitter-rails.context')

local function assert_eq(expected, actual, msg)
  if expected ~= actual then
    error(string.format('%s: expected %q, got %q', msg or 'Assertion failed', tostring(expected), tostring(actual)))
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

print('=== Context Detection Tests ===\n')

-- Standard Rails paths
test('detects model from app/models/', function()
  assert_eq('model', context.detect('app/models/user.rb'))
end)

test('detects model concerns', function()
  assert_eq('model', context.detect('app/models/concerns/searchable.rb'))
end)

test('detects controller from app/controllers/', function()
  assert_eq('controller', context.detect('app/controllers/users_controller.rb'))
end)

test('detects controller concerns', function()
  assert_eq('controller', context.detect('app/controllers/concerns/authenticatable.rb'))
end)

test('detects view from app/views/', function()
  assert_eq('view', context.detect('app/views/users/show.html.erb'))
end)

test('detects helper as view context', function()
  assert_eq('view', context.detect('app/helpers/application_helper.rb'))
end)

test('detects job from app/jobs/', function()
  assert_eq('job', context.detect('app/jobs/sync_job.rb'))
end)

test('detects mailer from app/mailers/', function()
  assert_eq('mailer', context.detect('app/mailers/user_mailer.rb'))
end)

test('detects migration from db/migrate/', function()
  assert_eq('migration', context.detect('db/migrate/20240101000000_create_users.rb'))
end)

test('detects schema.rb as migration', function()
  assert_eq('migration', context.detect('db/schema.rb'))
end)

test('detects routes from config/routes.rb', function()
  assert_eq('routes', context.detect('config/routes.rb'))
end)

test('detects routes from config/routes/', function()
  assert_eq('routes', context.detect('config/routes/api.rb'))
end)

-- RSpec tests
test('detects rspec from spec/models/', function()
  assert_eq('rspec', context.detect('spec/models/user_spec.rb'))
end)

test('detects rspec from spec/controllers/', function()
  assert_eq('rspec', context.detect('spec/controllers/users_controller_spec.rb'))
end)

test('detects rspec from spec/requests/', function()
  assert_eq('rspec', context.detect('spec/requests/api_spec.rb'))
end)

test('detects rspec from spec/features/', function()
  assert_eq('rspec', context.detect('spec/features/login_spec.rb'))
end)

test('detects rspec from spec/system/', function()
  assert_eq('rspec', context.detect('spec/system/checkout_spec.rb'))
end)

test('detects rspec from generic spec/', function()
  assert_eq('rspec', context.detect('spec/services/payment_service_spec.rb'))
end)

-- Minitest tests
test('detects minitest from test/models/', function()
  assert_eq('minitest', context.detect('test/models/user_test.rb'))
end)

test('detects minitest from test/controllers/', function()
  assert_eq('minitest', context.detect('test/controllers/users_controller_test.rb'))
end)

test('detects minitest from test/integration/', function()
  assert_eq('minitest', context.detect('test/integration/checkout_test.rb'))
end)

test('detects minitest from generic test/', function()
  assert_eq('minitest', context.detect('test/services/payment_service_test.rb'))
end)

-- Packwerk / packs support
print('\n=== Packwerk / Packs Support ===\n')

test('detects model in packs/', function()
  assert_eq('model', context.detect('packs/billing/app/models/invoice.rb'))
end)

test('detects model in packages/', function()
  assert_eq('model', context.detect('packages/auth/app/models/user.rb'))
end)

test('detects model in components/', function()
  assert_eq('model', context.detect('components/core/app/models/base_model.rb'))
end)

test('detects model in engines/', function()
  assert_eq('model', context.detect('engines/payments/app/models/transaction.rb'))
end)

test('detects controller in packs/', function()
  assert_eq('controller', context.detect('packs/api/app/controllers/api_controller.rb'))
end)

test('detects job in packs/', function()
  assert_eq('job', context.detect('packs/workers/app/jobs/process_job.rb'))
end)

test('detects mailer in packs/', function()
  assert_eq('mailer', context.detect('packs/notifications/app/mailers/alert_mailer.rb'))
end)

test('detects rspec in packs/', function()
  assert_eq('rspec', context.detect('packs/billing/spec/models/invoice_spec.rb'))
end)

test('detects minitest in packs/', function()
  assert_eq('minitest', context.detect('packs/billing/test/models/invoice_test.rb'))
end)

test('detects routes in packs/', function()
  assert_eq('routes', context.detect('packs/api/config/routes/v1.rb'))
end)

test('detects migration in packs/', function()
  assert_eq('migration', context.detect('packs/billing/db/migrate/20240101000000_create_invoices.rb'))
end)

-- Deeply nested packs
test('detects model in deeply nested packs/', function()
  assert_eq('model', context.detect('packs/domains/billing/app/models/invoice.rb'))
end)

-- Non-Rails files
print('\n=== Non-Rails Files ===\n')

test('returns nil for lib/', function()
  assert_eq(nil, context.detect('lib/my_gem.rb'))
end)

test('returns nil for config/', function()
  assert_eq(nil, context.detect('config/application.rb'))
end)

test('returns nil for initializers', function()
  assert_eq(nil, context.detect('config/initializers/devise.rb'))
end)

test('returns nil for Gemfile', function()
  assert_eq(nil, context.detect('Gemfile'))
end)

print('\n=== All tests completed ===')
