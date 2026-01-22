; treesitter-rails: Global Rails DSL patterns
; These patterns apply to all Ruby files in a Rails project
; They highlight ActiveSupport extensions and common Rails patterns

; =============================================================================
; ActiveSupport Core Extensions
; =============================================================================

; Delegation
((call
  method: (identifier) @function.macro.rails
  (#any-of? @function.macro.rails
    "delegate"
    "delegate_missing_to")))

; Class attributes
((call
  method: (identifier) @function.macro.rails
  (#any-of? @function.macro.rails
    "class_attribute"
    "cattr_accessor"
    "cattr_reader"
    "cattr_writer"
    "mattr_accessor"
    "mattr_reader"
    "mattr_writer"
    "thread_cattr_accessor"
    "thread_mattr_accessor")))

; with_options pattern
((call
  method: (identifier) @function.macro.rails
  (#eq? @function.macro.rails "with_options")))

; =============================================================================
; Concern DSL
; =============================================================================

((call
  method: (identifier) @function.macro.rails
  (#any-of? @function.macro.rails
    "included"
    "class_methods"
    "prepended")))

; ActiveSupport::Concern extend
((call
  method: (identifier) @function.macro.rails
  (#eq? @function.macro.rails "extend")
  arguments: (argument_list
    (scope_resolution
      scope: (constant) @_activesupport
      name: (constant) @_concern
      (#eq? @_activesupport "ActiveSupport")
      (#eq? @_concern "Concern")))))

; =============================================================================
; Module Inclusion
; =============================================================================

((call
  method: (identifier) @function.macro.rails
  (#any-of? @function.macro.rails
    "include"
    "extend"
    "prepend")))

; =============================================================================
; Deprecation
; =============================================================================

((call
  method: (identifier) @function.macro.rails
  (#any-of? @function.macro.rails
    "deprecate"
    "deprecate_constant")))

; =============================================================================
; Callbacks (generic)
; =============================================================================

((call
  method: (identifier) @function.macro.rails
  (#any-of? @function.macro.rails
    "define_callbacks"
    "set_callback"
    "skip_callback"
    "reset_callbacks"
    "run_callbacks")))

; =============================================================================
; Configuration DSL
; =============================================================================

((call
  method: (identifier) @function.macro.rails
  (#any-of? @function.macro.rails
    "config_accessor")))

; =============================================================================
; Autoloading
; =============================================================================

((call
  method: (identifier) @function.macro.rails
  (#any-of? @function.macro.rails
    "autoload"
    "eager_autoload")))

; =============================================================================
; Rails.application and Rails.env
; =============================================================================

; Rails.env checks
((call
  receiver: (call
    receiver: (constant) @_rails
    (#eq? @_rails "Rails")
    method: (identifier) @_env
    (#eq? @_env "env"))
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    "development?"
    "production?"
    "test?"
    "staging?")))

; Rails.application methods
((call
  receiver: (call
    receiver: (constant) @_rails
    (#eq? @_rails "Rails")
    method: (identifier) @_app
    (#eq? @_app "application"))
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    "config"
    "credentials"
    "secrets"
    "routes"
    "eager_load!"
    "load_tasks"
    "load_seed")))

; Rails.logger
((call
  receiver: (call
    receiver: (constant) @_rails
    (#eq? @_rails "Rails")
    method: (identifier) @_logger
    (#eq? @_logger "logger"))
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    "debug"
    "info"
    "warn"
    "error"
    "fatal"
    "unknown")))

; Rails.cache
((call
  receiver: (call
    receiver: (constant) @_rails
    (#eq? @_rails "Rails")
    method: (identifier) @_cache
    (#eq? @_cache "cache"))
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    "read"
    "write"
    "fetch"
    "delete"
    "exist?"
    "clear"
    "increment"
    "decrement")))

; =============================================================================
; Time helpers (ActiveSupport)
; =============================================================================

; Numeric time helpers: 1.day, 2.hours, etc.
; Note: These are method calls on numeric literals
((call
  receiver: (integer)
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    "second" "seconds"
    "minute" "minutes"
    "hour" "hours"
    "day" "days"
    "week" "weeks"
    "fortnight" "fortnights"
    "month" "months"
    "year" "years"
    "ago"
    "from_now"
    "since"
    "until"
    "before"
    "after")))

((call
  receiver: (float)
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    "second" "seconds"
    "minute" "minutes"
    "hour" "hours"
    "day" "days"
    "week" "weeks"
    "fortnight" "fortnights"
    "month" "months"
    "year" "years")))

; Chained time methods
((call
  receiver: (call)
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    "ago"
    "from_now"
    "since"
    "until"
    "before"
    "after")))

; =============================================================================
; Byte helpers (ActiveSupport)
; =============================================================================

((call
  receiver: (integer)
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    "byte" "bytes"
    "kilobyte" "kilobytes"
    "megabyte" "megabytes"
    "gigabyte" "gigabytes"
    "terabyte" "terabytes"
    "petabyte" "petabytes"
    "exabyte" "exabytes")))
