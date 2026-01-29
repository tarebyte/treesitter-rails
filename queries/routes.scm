; =============================================================================
; HTTP Verb Methods
; =============================================================================

((call
  method: (identifier) @keyword.rails.route
  (#any-of? @keyword.rails.route
    "get"
    "post"
    "put"
    "patch"
    "delete"
    "options"
    "head"
    "match")))

; =============================================================================
; Resource Routing
; =============================================================================

((call
  method: (identifier) @keyword.rails.route
  (#any-of? @keyword.rails.route
    "resources"
    "resource"
    "shallow")))

; =============================================================================
; Route Root
; =============================================================================

((call
  method: (identifier) @keyword.rails.route
  (#eq? @keyword.rails.route "root")))

; =============================================================================
; Nested Routes and Scoping
; =============================================================================

((call
  method: (identifier) @keyword.rails.route
  (#any-of? @keyword.rails.route
    "namespace"
    "scope"
    "controller"
    "constraints"
    "defaults"
    "shallow")))

; =============================================================================
; Member and Collection Routes
; =============================================================================

((call
  method: (identifier) @keyword.rails.route
  (#any-of? @keyword.rails.route
    "member"
    "collection"
    "new")))

; =============================================================================
; Concerns
; =============================================================================

((call
  method: (identifier) @keyword.rails.route
  (#any-of? @keyword.rails.route
    "concern"
    "concerns")))

; =============================================================================
; Route Drawing
; =============================================================================

((call
  method: (identifier) @keyword.rails.route
  (#any-of? @keyword.rails.route
    "draw"
    "direct"
    "resolve")))

; =============================================================================
; Mounting and Engines
; =============================================================================

((call
  method: (identifier) @keyword.rails.route
  (#any-of? @keyword.rails.route
    "mount")))

; =============================================================================
; Redirect Routes
; =============================================================================

((call
  method: (identifier) @keyword.rails.route
  (#eq? @keyword.rails.route "redirect")))

; =============================================================================
; Health Check and Rails Default Routes
; =============================================================================

((call
  method: (identifier) @keyword.rails.route
  (#any-of? @keyword.rails.route
    "health_check")))

; =============================================================================
; Route Application
; =============================================================================

((call
  receiver: (scope_resolution
    name: (constant) @_rails
    (#eq? @_rails "Application"))
  method: (identifier) @_routes
  (#eq? @_routes "routes")))

; Alternative: Rails.application.routes.draw
((call
  receiver: (call
    receiver: (call
      receiver: (constant) @_rails
      (#eq? @_rails "Rails")
      method: (identifier) @_app
      (#eq? @_app "application"))
    method: (identifier) @_routes
    (#eq? @_routes "routes"))
  method: (identifier) @keyword.rails.route
  (#eq? @keyword.rails.route "draw")))

; =============================================================================
; Route Options (via, as, to, etc. as hash keys)
; =============================================================================

; These are typically used as options in route definitions
; e.g., get '/path', to: 'controller#action', as: :named_route

; =============================================================================
; Action Cable Routing
; =============================================================================

((call
  method: (identifier) @keyword.rails.route
  (#eq? @keyword.rails.route "mount_devise_token_auth_for")))

; =============================================================================
; API Mode Routing
; =============================================================================

((call
  method: (identifier) @keyword.rails.route
  (#any-of? @keyword.rails.route
    "api_only")))

; =============================================================================
; Nested do blocks with route helpers
; =============================================================================

; Pattern: resources :users do ... end
; The 'do' block content will have these patterns matched

; =============================================================================
; Legacy Routing (Rails 2-3 style)
; =============================================================================

((call
  method: (identifier) @keyword.rails.route
  (#any-of? @keyword.rails.route
    "map")))
