--- Controller query patterns for treesitter-rails
--- Covers filters, response methods, helpers, and controller configuration
--- @module treesitter-rails.queries.controller

local M = {}

M.query = [[
; =============================================================================
; Controller Filters (Callbacks)
; =============================================================================

((call
  method: (identifier) @function.macro.rails.filter
  (#any-of? @function.macro.rails.filter
    ; Before filters
    "before_action"
    "prepend_before_action"
    "append_before_action"
    "skip_before_action"
    ; After filters
    "after_action"
    "prepend_after_action"
    "append_after_action"
    "skip_after_action"
    ; Around filters
    "around_action"
    "prepend_around_action"
    "append_around_action"
    "skip_around_action")))

; =============================================================================
; Response Methods
; =============================================================================

((call
  method: (identifier) @keyword.rails.response
  (#any-of? @keyword.rails.response
    ; Rendering
    "render"
    "render_to_string"
    ; Redirects
    "redirect_to"
    "redirect_back"
    "redirect_back_or_to"
    ; Head responses
    "head"
    ; Sending data
    "send_data"
    "send_file"
    ; Streaming
    "stream_csv"
    "stream_text")))

; =============================================================================
; Controller Helpers (Built-in Objects)
; =============================================================================

; params, request, response, session, cookies, flash, etc.
((identifier) @variable.builtin.rails
  (#any-of? @variable.builtin.rails
    "params"
    "request"
    "response"
    "session"
    "cookies"
    "flash"
    "headers"
    "env"))

; =============================================================================
; Layout and View Configuration
; =============================================================================

((call
  method: (identifier) @function.macro.rails.filter
  (#any-of? @function.macro.rails.filter
    "layout"
    "helper"
    "helper_method"
    "helper_attr"
    "hide_action")))

; =============================================================================
; Response Format
; =============================================================================

; respond_to, respond_with
((call
  method: (identifier) @keyword.rails.response
  (#any-of? @keyword.rails.response
    "respond_to"
    "respond_with")))

; Format types in respond_to block
((call
  receiver: (identifier) @_receiver
  (#eq? @_receiver "format")
  method: (identifier) @keyword.rails.response
  (#any-of? @keyword.rails.response
    "html"
    "json"
    "js"
    "xml"
    "text"
    "csv"
    "pdf"
    "any"
    "all")))

; =============================================================================
; Strong Parameters
; =============================================================================

; params.require, params.permit
((call
  receiver: (identifier) @_params
  (#eq? @_params "params")
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    "require"
    "permit"
    "fetch"
    "slice"
    "except"
    "to_unsafe_h")))

; Chained permit after require
((call
  receiver: (call)
  method: (identifier) @function.rails.helper
  (#eq? @function.rails.helper "permit")))

; =============================================================================
; Authentication and Authorization Helpers
; =============================================================================

; Common authentication methods
((call
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    "authenticate_user!"
    "current_user"
    "user_signed_in?"
    "warden")))

; Common authorization patterns
((call
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    "authorize"
    "authorize!"
    "policy"
    "pundit_user"
    "skip_authorization"
    "skip_policy_scope")))

; =============================================================================
; Rescues and Error Handling
; =============================================================================

((call
  method: (identifier) @function.macro.rails.filter
  (#any-of? @function.macro.rails.filter
    "rescue_from"
    "rescue_with_handler")))

; =============================================================================
; Caching
; =============================================================================

((call
  method: (identifier) @function.macro.rails.filter
  (#any-of? @function.macro.rails.filter
    "caches_action"
    "caches_page"
    "cache_page"
    "expire_page"
    "expire_action")))

((call
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    "fresh_when"
    "stale?"
    "expires_in"
    "expires_now"
    "http_cache_forever")))

; =============================================================================
; URL Helpers
; =============================================================================

; Common URL/path helpers pattern (ending in _path or _url)
((identifier) @function.rails.helper
  (#lua-match? @function.rails.helper "^%w+_path$"))

((identifier) @function.rails.helper
  (#lua-match? @function.rails.helper "^%w+_url$"))

; Explicit URL helpers
((call
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    "url_for"
    "polymorphic_path"
    "polymorphic_url")))

; =============================================================================
; Controller Configuration
; =============================================================================

((call
  method: (identifier) @function.macro.rails
  (#any-of? @function.macro.rails
    "protect_from_forgery"
    "skip_forgery_protection"
    "verify_authenticity_token"
    "allow_browser"
    "rate_limit")))

; =============================================================================
; Session and Cookie Methods
; =============================================================================

((call
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    "reset_session"
    "signed_cookies"
    "encrypted_cookies")))

; =============================================================================
; Content Negotiation
; =============================================================================

((call
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    "request_http_token_authentication"
    "authenticate_or_request_with_http_basic"
    "authenticate_or_request_with_http_token"
    "authenticate_or_request_with_http_digest")))

; =============================================================================
; Action Controller Extensions
; =============================================================================

((call
  method: (identifier) @function.macro.rails
  (#any-of? @function.macro.rails
    "include"
    "extend"
    "prepend"
    "concerns")))
]]

return M
