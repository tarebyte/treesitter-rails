--- Job query patterns for treesitter-rails
--- Covers ActiveJob DSL
--- @module treesitter-rails.queries.job

local M = {}

M.query = [[
; =============================================================================
; Queue Configuration
; =============================================================================

((call
  method: (identifier) @function.macro.rails.job
  (#any-of? @function.macro.rails.job
    "queue_as"
    "queue_with_priority")))

; =============================================================================
; Retry and Discard Configuration
; =============================================================================

((call
  method: (identifier) @function.macro.rails.job
  (#any-of? @function.macro.rails.job
    "retry_on"
    "discard_on")))

; =============================================================================
; Callbacks
; =============================================================================

((call
  method: (identifier) @function.macro.rails.callback
  (#any-of? @function.macro.rails.callback
    ; Enqueue callbacks
    "before_enqueue"
    "around_enqueue"
    "after_enqueue"
    ; Perform callbacks
    "before_perform"
    "around_perform"
    "after_perform")))

; =============================================================================
; Job Invocation
; =============================================================================

((call
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    "perform_now"
    "perform_later"
    "set"
    "enqueue")))

; Chained set calls
((call
  receiver: (call)
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    "perform_now"
    "perform_later"
    "set")))

; =============================================================================
; Sidekiq Integration
; =============================================================================

((call
  method: (identifier) @function.macro.rails.job
  (#any-of? @function.macro.rails.job
    "sidekiq_options"
    "sidekiq_retry_in"
    "sidekiq_retries_exhausted")))

; =============================================================================
; Delayed Job Integration
; =============================================================================

((call
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    "delay"
    "delay_for"
    "delay_until")))

; =============================================================================
; GoodJob Integration
; =============================================================================

((call
  method: (identifier) @function.macro.rails.job
  (#any-of? @function.macro.rails.job
    "good_job_control_concurrency_with")))

; =============================================================================
; Solid Queue Integration
; =============================================================================

((call
  method: (identifier) @function.macro.rails.job
  (#any-of? @function.macro.rails.job
    "limits_concurrency")))

; =============================================================================
; Job Attributes
; =============================================================================

((identifier) @variable.builtin.rails
  (#any-of? @variable.builtin.rails
    "job_id"
    "queue_name"
    "priority"
    "arguments"
    "serialized_arguments"
    "scheduled_at"
    "executions"
    "exception_executions"))
]]

return M
