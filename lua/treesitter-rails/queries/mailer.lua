--- Mailer query patterns for treesitter-rails
--- Covers ActionMailer DSL
--- @module treesitter-rails.queries.mailer

local M = {}

M.query = [[
; =============================================================================
; Mail Configuration
; =============================================================================

((call
  method: (identifier) @function.macro.rails.mailer
  (#any-of? @function.macro.rails.mailer
    "default"
    "layout")))

; =============================================================================
; Mail Building
; =============================================================================

((call
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    "mail"
    "headers")))

; =============================================================================
; Attachments
; =============================================================================

((identifier) @variable.builtin.rails
  (#eq? @variable.builtin.rails "attachments"))

((call
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    "inline")))

; =============================================================================
; Callbacks
; =============================================================================

((call
  method: (identifier) @function.macro.rails.callback
  (#any-of? @function.macro.rails.callback
    "before_action"
    "after_action"
    "around_action"
    "after_deliver"
    "before_deliver"
    "around_deliver")))

; =============================================================================
; Delivery Methods
; =============================================================================

((call
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    "deliver_now"
    "deliver_later"
    "deliver_now!"
    "deliver_later!")))

; Chained delivery after mailer method
((call
  receiver: (call)
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    "deliver_now"
    "deliver_later"
    "deliver_now!"
    "deliver_later!")))

; =============================================================================
; Mailer Helpers
; =============================================================================

((call
  method: (identifier) @function.macro.rails.mailer
  (#any-of? @function.macro.rails.mailer
    "helper"
    "helper_method"
    "helper_attr")))

; =============================================================================
; Interceptors and Observers
; =============================================================================

((call
  method: (identifier) @function.macro.rails.mailer
  (#any-of? @function.macro.rails.mailer
    "register_interceptor"
    "register_interceptors"
    "unregister_interceptor"
    "unregister_interceptors"
    "register_observer"
    "register_observers"
    "unregister_observer"
    "unregister_observers"
    "register_preview_interceptor"
    "register_preview_interceptors"
    "unregister_preview_interceptor"
    "unregister_preview_interceptors")))

; =============================================================================
; Rescues
; =============================================================================

((call
  method: (identifier) @function.macro.rails.mailer
  (#eq? @function.macro.rails.mailer "rescue_from")))

; =============================================================================
; Mailer Attributes
; =============================================================================

((identifier) @variable.builtin.rails
  (#any-of? @variable.builtin.rails
    "params"
    "message"))
]]

return M
