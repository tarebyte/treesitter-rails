--- View query patterns for treesitter-rails
--- Covers form helpers, URL helpers, asset helpers, and view utilities
--- @module treesitter-rails.queries.view

local M = {}

M.query = [[
; =============================================================================
; Form Helpers
; =============================================================================

; Form builders
((call
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    "form_for"
    "form_with"
    "form_tag"
    "fields_for"
    "fields")))

; Form input helpers
((call
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    ; Text inputs
    "text_field"
    "text_field_tag"
    "password_field"
    "password_field_tag"
    "hidden_field"
    "hidden_field_tag"
    "text_area"
    "text_area_tag"
    "search_field"
    "search_field_tag"
    "telephone_field"
    "telephone_field_tag"
    "phone_field"
    "url_field"
    "url_field_tag"
    "email_field"
    "email_field_tag"
    "number_field"
    "number_field_tag"
    "range_field"
    "range_field_tag"
    "color_field"
    "color_field_tag"
    ; Date/time inputs
    "date_field"
    "date_field_tag"
    "time_field"
    "time_field_tag"
    "datetime_field"
    "datetime_field_tag"
    "datetime_local_field"
    "datetime_local_field_tag"
    "month_field"
    "month_field_tag"
    "week_field"
    "week_field_tag"
    ; Selection helpers
    "select"
    "select_tag"
    "collection_select"
    "collection_radio_buttons"
    "collection_check_boxes"
    "grouped_collection_select"
    "time_zone_select"
    ; Checkbox/radio
    "check_box"
    "check_box_tag"
    "radio_button"
    "radio_button_tag"
    ; File
    "file_field"
    "file_field_tag"
    ; Buttons
    "submit"
    "submit_tag"
    "button"
    "button_tag"
    "button_to"
    ; Labels
    "label"
    "label_tag")))

; Rich text (Action Text)
((call
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    "rich_text_area"
    "rich_text_area_tag")))

; =============================================================================
; Link Helpers
; =============================================================================

((call
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    "link_to"
    "link_to_if"
    "link_to_unless"
    "link_to_unless_current"
    "mail_to"
    "button_to")))

; =============================================================================
; URL Helpers
; =============================================================================

((call
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    "url_for"
    "polymorphic_path"
    "polymorphic_url"
    "edit_polymorphic_path"
    "edit_polymorphic_url"
    "new_polymorphic_path"
    "new_polymorphic_url")))

; Named route helpers (ending in _path or _url)
((identifier) @function.rails.helper
  (#lua-match? @function.rails.helper "^%w+_path$"))

((identifier) @function.rails.helper
  (#lua-match? @function.rails.helper "^%w+_url$"))

; =============================================================================
; Asset Helpers
; =============================================================================

((call
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    ; Images
    "image_tag"
    "image_path"
    "image_url"
    ; JavaScript
    "javascript_include_tag"
    "javascript_tag"
    "javascript_path"
    "javascript_url"
    "javascript_importmap_tags"
    ; Stylesheets
    "stylesheet_link_tag"
    "stylesheet_path"
    "stylesheet_url"
    ; Other assets
    "asset_path"
    "asset_url"
    "audio_tag"
    "audio_path"
    "audio_url"
    "video_tag"
    "video_path"
    "video_url"
    "font_path"
    "font_url"
    ; Favicon
    "favicon_link_tag"
    ; Preload
    "preload_link_tag")))

; =============================================================================
; Content Helpers
; =============================================================================

((call
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    "content_for"
    "content_for?"
    "provide"
    "yield"
    "content_tag"
    "content_tag_for"
    "tag"
    "capture"
    "concat")))

; =============================================================================
; Rendering Helpers
; =============================================================================

((call
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    "render"
    "render_to_string"
    "render_partial")))

; =============================================================================
; Sanitization and Escaping
; =============================================================================

((call
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    "sanitize"
    "sanitize_css"
    "strip_tags"
    "strip_links"
    "escape_once"
    "html_escape"
    "h"
    "raw"
    "safe_join")))

; =============================================================================
; Number and Text Formatting
; =============================================================================

((call
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    ; Numbers
    "number_to_currency"
    "number_to_human"
    "number_to_human_size"
    "number_to_percentage"
    "number_to_phone"
    "number_with_delimiter"
    "number_with_precision"
    ; Text
    "truncate"
    "highlight"
    "excerpt"
    "pluralize"
    "word_wrap"
    "simple_format"
    "cycle"
    "reset_cycle"
    "current_cycle")))

; =============================================================================
; Date and Time Helpers
; =============================================================================

((call
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    "distance_of_time_in_words"
    "distance_of_time_in_words_to_now"
    "time_ago_in_words"
    "date_select"
    "time_select"
    "datetime_select"
    "select_date"
    "select_datetime"
    "select_day"
    "select_hour"
    "select_minute"
    "select_month"
    "select_second"
    "select_time"
    "select_year")))

; =============================================================================
; Translation / I18n
; =============================================================================

((call
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    "t"
    "translate"
    "l"
    "localize")))

; =============================================================================
; CSRF and Security
; =============================================================================

((call
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    "csrf_meta_tags"
    "csrf_meta_tag"
    "form_authenticity_token"
    "csp_meta_tag")))

; =============================================================================
; Turbo and Hotwire
; =============================================================================

((call
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    "turbo_frame_tag"
    "turbo_stream_from"
    "turbo_stream"
    "turbo_include_tags"
    "turbo_refreshes_with"
    "stimulus_include_tags")))

; =============================================================================
; Action Cable
; =============================================================================

((call
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    "action_cable_meta_tag")))

; =============================================================================
; Cache Helpers
; =============================================================================

((call
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    "cache"
    "cache_if"
    "cache_unless"
    "cache_fragment_name")))

; =============================================================================
; Debug Helpers
; =============================================================================

((call
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    "debug"
    "inspect")))

; =============================================================================
; Active Storage
; =============================================================================

((call
  method: (identifier) @function.rails.helper
  (#any-of? @function.rails.helper
    "rails_blob_path"
    "rails_blob_url"
    "rails_representation_path"
    "rails_representation_url"
    "rails_storage_redirect_path"
    "rails_storage_redirect_url"
    "rails_storage_proxy_path"
    "rails_storage_proxy_url")))

; =============================================================================
; Built-in View Objects
; =============================================================================

((identifier) @variable.builtin.rails
  (#any-of? @variable.builtin.rails
    "controller"
    "action_name"
    "controller_name"
    "controller_path"
    "params"
    "request"
    "response"
    "session"
    "cookies"
    "flash"
    "assigns"))
]]

return M
