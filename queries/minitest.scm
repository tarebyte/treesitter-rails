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

; =============================================================================
; Rails Test Helpers (shared)
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
; Factory Bot / Fabrication (shared)
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
; Shoulda Matchers (shared)
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
; Database Cleaner (shared)
; =============================================================================

((call
  method: (identifier) @function.macro.rails.test
  (#any-of? @function.macro.rails.test
    "use_transactional_fixtures"
    "use_transactional_tests")))

; =============================================================================
; Fixtures (shared)
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
