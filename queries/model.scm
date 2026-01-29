; =============================================================================
; Associations
; =============================================================================

; belongs_to, has_one, has_many, has_and_belongs_to_many
((call
  method: (identifier) @function.macro.rails.association
  (#any-of? @function.macro.rails.association
    "belongs_to"
    "has_one"
    "has_many"
    "has_and_belongs_to_many"
    "composed_of")))

; =============================================================================
; Validations
; =============================================================================

; All validation methods
((call
  method: (identifier) @function.macro.rails.validation
  (#any-of? @function.macro.rails.validation
    "validates"
    "validates!"
    "validate"
    "validates_associated"
    "validates_acceptance_of"
    "validates_confirmation_of"
    "validates_exclusion_of"
    "validates_format_of"
    "validates_inclusion_of"
    "validates_length_of"
    "validates_numericality_of"
    "validates_presence_of"
    "validates_absence_of"
    "validates_size_of"
    "validates_uniqueness_of"
    "validates_with"
    "validates_each")))

; =============================================================================
; Callbacks
; =============================================================================

; Model callbacks
((call
  method: (identifier) @function.macro.rails.callback
  (#any-of? @function.macro.rails.callback
    ; Validation callbacks
    "before_validation"
    "after_validation"
    ; Save callbacks
    "before_save"
    "around_save"
    "after_save"
    ; Create callbacks
    "before_create"
    "around_create"
    "after_create"
    ; Update callbacks
    "before_update"
    "around_update"
    "after_update"
    ; Destroy callbacks
    "before_destroy"
    "around_destroy"
    "after_destroy"
    ; Commit/rollback callbacks
    "after_commit"
    "after_create_commit"
    "after_update_commit"
    "after_destroy_commit"
    "after_save_commit"
    "after_rollback"
    ; Find callbacks
    "after_find"
    "after_initialize"
    ; Touch callbacks
    "after_touch")))

; =============================================================================
; Scopes
; =============================================================================

((call
  method: (identifier) @function.macro.rails.attribute
  (#any-of? @function.macro.rails.attribute
    "scope"
    "default_scope")))

; =============================================================================
; Attribute macros
; =============================================================================

((call
  method: (identifier) @function.macro.rails.attribute
  (#any-of? @function.macro.rails.attribute
    ; Enums
    "enum"
    ; Store
    "store"
    "store_accessor"
    ; Serialization
    "serialize"
    ; Attribute API
    "attribute"
    "attribute_method_prefix"
    "attribute_method_suffix"
    "attribute_method_affix"
    ; Normalization
    "normalizes"
    ; Encryption
    "encrypts"
    ; Delegation
    "delegate"
    "delegate_missing_to"
    ; Aliasing
    "alias_attribute")))

; =============================================================================
; Query interface class methods
; =============================================================================

((call
  method: (identifier) @function.macro.rails.attribute
  (#any-of? @function.macro.rails.attribute
    ; Finders
    "find"
    "find_by"
    "find_by!"
    "find_or_create_by"
    "find_or_create_by!"
    "find_or_initialize_by"
    "first_or_create"
    "first_or_create!"
    "first_or_initialize"
    "create_or_find_by"
    "create_or_find_by!"
    ; Scoping
    "where"
    "not"
    "or"
    "and"
    "order"
    "reorder"
    "group"
    "having"
    "limit"
    "offset"
    "joins"
    "left_joins"
    "left_outer_joins"
    "includes"
    "preload"
    "eager_load"
    "references"
    "select"
    "distinct"
    "from"
    "extending"
    "lock"
    "readonly"
    "reselect"
    "rewhere"
    "unscope"
    "merge"
    "except"
    "only"
    "none")))

; =============================================================================
; Nested attributes
; =============================================================================

((call
  method: (identifier) @function.macro.rails.attribute
  (#eq? @function.macro.rails.attribute "accepts_nested_attributes_for")))

; =============================================================================
; Secure password
; =============================================================================

((call
  method: (identifier) @function.macro.rails.attribute
  (#eq? @function.macro.rails.attribute "has_secure_password")))

((call
  method: (identifier) @function.macro.rails.attribute
  (#eq? @function.macro.rails.attribute "has_secure_token")))

; =============================================================================
; ActiveRecord configuration
; =============================================================================

((call
  method: (identifier) @function.macro.rails.attribute
  (#any-of? @function.macro.rails.attribute
    "self.table_name="
    "self.primary_key="
    "self.inheritance_column="
    "table_name="
    "primary_key="
    "inheritance_column="
    "establish_connection"
    "connected_to"
    "connects_to")))

; Simple table_name, primary_key assignments
((assignment
  left: (call
    receiver: (self)
    method: (identifier) @function.macro.rails.attribute
    (#any-of? @function.macro.rails.attribute
      "table_name"
      "primary_key"
      "inheritance_column"))))

; =============================================================================
; ActiveRecord attribute macros
; =============================================================================

((call
  method: (identifier) @function.macro.rails
  (#eq? @function.macro.rails "attr_readonly")))
