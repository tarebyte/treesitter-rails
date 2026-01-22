--- Test query patterns for treesitter-rails
--- Covers Minitest and RSpec DSL
--- @module treesitter-rails.queries.test

local M = {}

-- Shared patterns for both Minitest and RSpec
local shared = [[
; =============================================================================
; Rails Test Helpers
; =============================================================================

; Request helpers
((call
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    "get"
    "post"
    "put"
    "patch"
    "delete"
    "head"
    "options")))

; Response helpers
((identifier) @variable.builtin.rails
  (#any-of? @variable.builtin.rails
    "response"
    "request"
    "session"
    "flash"
    "cookies"
    "assigns"
    "controller"))

; =============================================================================
; Factory Bot / Fabrication
; =============================================================================

((call
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    ; Factory Bot
    "create"
    "build"
    "build_stubbed"
    "attributes_for"
    "create_list"
    "build_list"
    "create_pair"
    "build_pair"
    ; Fabrication
    "Fabricate")))

; =============================================================================
; Shoulda Matchers
; =============================================================================

((call
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    ; ActiveRecord matchers
    "belong_to"
    "have_one"
    "have_many"
    "have_and_belong_to_many"
    "have_db_column"
    "have_db_index"
    "have_readonly_attribute"
    "have_rich_text"
    "have_secure_password"
    "serialize"
    ; Validation matchers
    "validate_presence_of"
    "validate_absence_of"
    "validate_acceptance_of"
    "validate_confirmation_of"
    "validate_exclusion_of"
    "validate_inclusion_of"
    "validate_length_of"
    "validate_numericality_of"
    "validate_uniqueness_of"
    "allow_value"
    "allow_values"
    ; Callback matchers
    "callback")))

; =============================================================================
; Database Cleaner
; =============================================================================

((call
  method: (identifier) @function.macro.rails.test
  (#any-of? @function.macro.rails.test
    "use_transactional_fixtures"
    "use_transactional_tests")))

; =============================================================================
; Fixtures
; =============================================================================

((call
  method: (identifier) @function.macro.rails.test
  (#any-of? @function.macro.rails.test
    "fixtures"
    "fixture_path"
    "file_fixture")))

; Fixture accessor
((call
  method: (identifier) @function.rails.helper
  (#lua-match? @function.rails.helper "^[a-z_]+$"))
  (#not-any-of? @function.rails.helper
    "it" "describe" "context" "before" "after" "let" "subject"
    "expect" "allow" "receive" "assert" "refute"))
]]

-- Minitest-specific patterns
M.minitest = [[
; =============================================================================
; Minitest Structure
; =============================================================================

((call
  method: (identifier) @function.macro.rails.test
  (#any-of? @function.macro.rails.test
    "test"
    "setup"
    "teardown")))

; =============================================================================
; Minitest Assertions
; =============================================================================

((call
  method: (identifier) @function.rails.assertion
  (#any-of? @function.rails.assertion
    ; Basic assertions
    "assert"
    "assert_not"
    "refute"
    "assert_equal"
    "assert_not_equal"
    "refute_equal"
    "assert_same"
    "assert_not_same"
    "refute_same"
    "assert_nil"
    "assert_not_nil"
    "refute_nil"
    "assert_empty"
    "assert_not_empty"
    "refute_empty"
    "assert_includes"
    "assert_not_includes"
    "refute_includes"
    "assert_match"
    "assert_no_match"
    "refute_match"
    "assert_in_delta"
    "assert_not_in_delta"
    "refute_in_delta"
    "assert_in_epsilon"
    "assert_not_in_epsilon"
    "refute_in_epsilon"
    "assert_instance_of"
    "assert_not_instance_of"
    "refute_instance_of"
    "assert_kind_of"
    "assert_not_kind_of"
    "refute_kind_of"
    "assert_respond_to"
    "assert_not_respond_to"
    "refute_respond_to"
    "assert_operator"
    "assert_not_operator"
    "refute_operator"
    "assert_predicate"
    "assert_not_predicate"
    "refute_predicate"
    "assert_raises"
    "assert_nothing_raised"
    "assert_throws"
    "assert_silent"
    "assert_output"
    "assert_path_exists"
    "assert_path_not_exists"
    "refute_path_exists"
    ; Rails-specific assertions
    "assert_difference"
    "assert_no_difference"
    "assert_changes"
    "assert_no_changes"
    "assert_response"
    "assert_redirected_to"
    "assert_template"
    "assert_select"
    "assert_select_encoded"
    "assert_select_email"
    "css_select"
    "assert_enqueued_jobs"
    "assert_no_enqueued_jobs"
    "assert_performed_jobs"
    "assert_no_performed_jobs"
    "assert_enqueued_with"
    "assert_performed_with"
    "assert_enqueued_emails"
    "assert_no_enqueued_emails"
    "assert_emails"
    "assert_no_emails"
    "assert_broadcast_on"
    "assert_broadcasts"
    "assert_no_broadcasts")))

; =============================================================================
; Minitest Mocking/Stubbing
; =============================================================================

((call
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    "stub"
    "mock"
    "stub_any_instance")))

]] .. shared

-- RSpec-specific patterns
M.rspec = [[
; =============================================================================
; RSpec Structure
; =============================================================================

((call
  method: (identifier) @function.macro.rails.test
  (#any-of? @function.macro.rails.test
    "describe"
    "context"
    "feature"
    "scenario"
    "xdescribe"
    "xcontext"
    "xfeature"
    "xscenario"
    "fdescribe"
    "fcontext"
    "ffeature"
    "fscenario")))

((call
  method: (identifier) @function.macro.rails.test
  (#any-of? @function.macro.rails.test
    "it"
    "specify"
    "example"
    "xit"
    "xspecify"
    "xexample"
    "fit"
    "fspecify"
    "fexample"
    "pending"
    "skip")))

; =============================================================================
; RSpec Hooks
; =============================================================================

((call
  method: (identifier) @function.macro.rails.test
  (#any-of? @function.macro.rails.test
    "before"
    "after"
    "around"
    "prepend_before"
    "prepend_after"
    "append_before"
    "append_after")))

; =============================================================================
; RSpec Let/Subject
; =============================================================================

((call
  method: (identifier) @function.macro.rails.test
  (#any-of? @function.macro.rails.test
    "let"
    "let!"
    "subject"
    "subject!")))

; =============================================================================
; RSpec Expectations
; =============================================================================

((call
  method: (identifier) @function.rails.assertion
  (#any-of? @function.rails.assertion
    "expect"
    "expect_any_instance_of"
    "is_expected")))

; =============================================================================
; RSpec Matchers
; =============================================================================

((call
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    "to"
    "not_to"
    "to_not"
    ; Equality matchers
    "eq"
    "eql"
    "equal"
    "be"
    "be_truthy"
    "be_falsey"
    "be_falsy"
    "be_nil"
    "be_empty"
    "be_present"
    "be_blank"
    "be_valid"
    "be_invalid"
    "be_persisted"
    "be_new_record"
    "be_a"
    "be_an"
    "be_a_kind_of"
    "be_an_instance_of"
    ; Comparison matchers
    "be_between"
    "be_within"
    ; Collection matchers
    "include"
    "contain_exactly"
    "match_array"
    "start_with"
    "end_with"
    "all"
    "have_attributes"
    ; Change matchers
    "change"
    "by"
    "from"
    ; Error matchers
    "raise_error"
    "raise_exception"
    "throw_symbol"
    ; Output matchers
    "output"
    ; Predicate matchers
    "have_key"
    "have_value"
    ; Response matchers
    "have_http_status"
    "redirect_to"
    "render_template"
    ; Job/mail matchers
    "have_enqueued_job"
    "have_performed_job"
    "have_enqueued_mail"
    "have_sent_email"
    "have_broadcasted_to"
    ; Custom matchers
    "match"
    "satisfy")))

; =============================================================================
; RSpec Mocking/Stubbing
; =============================================================================

((call
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    "allow"
    "allow_any_instance_of"
    "receive"
    "receive_messages"
    "receive_message_chain"
    "and_return"
    "and_raise"
    "and_throw"
    "and_yield"
    "and_call_original"
    "and_wrap_original"
    "with"
    "once"
    "twice"
    "exactly"
    "at_least"
    "at_most"
    "times"
    "ordered"
    "double"
    "instance_double"
    "class_double"
    "object_double"
    "spy"
    "instance_spy"
    "class_spy"
    "object_spy"
    "have_received")))

; =============================================================================
; RSpec Shared Examples/Contexts
; =============================================================================

((call
  method: (identifier) @function.macro.rails.test
  (#any-of? @function.macro.rails.test
    "shared_examples"
    "shared_examples_for"
    "shared_context"
    "include_examples"
    "include_context"
    "it_behaves_like"
    "it_should_behave_like")))

; =============================================================================
; RSpec Metadata
; =============================================================================

((call
  method: (identifier) @function.macro.rails.test
  (#any-of? @function.macro.rails.test
    "aggregate_failures")))

]] .. shared

-- Default query (can be used for generic test files)
M.query = M.rspec

return M
