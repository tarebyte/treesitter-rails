; =============================================================================
; Table Operations
; =============================================================================

((call
  method: (identifier) @keyword.rails.schema
  (#any-of? @keyword.rails.schema
    "create_table"
    "create_join_table"
    "drop_table"
    "drop_join_table"
    "rename_table"
    "change_table")))

; =============================================================================
; Column Operations
; =============================================================================

((call
  method: (identifier) @keyword.rails.schema
  (#any-of? @keyword.rails.schema
    "add_column"
    "remove_column"
    "remove_columns"
    "rename_column"
    "change_column"
    "change_column_default"
    "change_column_null"
    "change_column_comment")))

; =============================================================================
; Column Types (inside create_table/change_table blocks)
; =============================================================================

((call
  receiver: (identifier) @_t
  (#match? @_t "^t$")
  method: (identifier) @keyword.rails.schema
  (#any-of? @keyword.rails.schema
    ; Standard types
    "string"
    "text"
    "integer"
    "bigint"
    "float"
    "decimal"
    "numeric"
    "datetime"
    "timestamp"
    "time"
    "date"
    "binary"
    "blob"
    "boolean"
    "json"
    "jsonb"
    "uuid"
    "inet"
    "cidr"
    "macaddr"
    "hstore"
    "point"
    "line"
    "lseg"
    "box"
    "path"
    "polygon"
    "circle"
    "bit"
    "bit_varying"
    "money"
    "xml"
    "tsvector"
    "tsquery"
    "int4range"
    "int8range"
    "numrange"
    "tsrange"
    "tstzrange"
    "daterange"
    "virtual"
    ; Special columns
    "timestamps"
    "column"
    "primary_key"
    "references"
    "belongs_to"
    ; Change table specific
    "change"
    "change_default"
    "change_null"
    "remove"
    "rename"
    ; Index and constraints
    "index"
    "remove_index"
    "foreign_key"
    "remove_foreign_key"
    "check_constraint"
    "remove_check_constraint")))

; =============================================================================
; Index Operations
; =============================================================================

((call
  method: (identifier) @keyword.rails.schema
  (#any-of? @keyword.rails.schema
    "add_index"
    "remove_index"
    "rename_index")))

; =============================================================================
; Foreign Key Operations
; =============================================================================

((call
  method: (identifier) @keyword.rails.schema
  (#any-of? @keyword.rails.schema
    "add_foreign_key"
    "remove_foreign_key")))

; =============================================================================
; Reference Operations
; =============================================================================

((call
  method: (identifier) @keyword.rails.schema
  (#any-of? @keyword.rails.schema
    "add_reference"
    "add_belongs_to"
    "remove_reference"
    "remove_belongs_to")))

; =============================================================================
; Constraint Operations
; =============================================================================

((call
  method: (identifier) @keyword.rails.schema
  (#any-of? @keyword.rails.schema
    "add_check_constraint"
    "remove_check_constraint"
    "add_exclusion_constraint"
    "remove_exclusion_constraint"
    "add_unique_constraint"
    "remove_unique_constraint")))

; =============================================================================
; Enum Operations (PostgreSQL)
; =============================================================================

((call
  method: (identifier) @keyword.rails.schema
  (#any-of? @keyword.rails.schema
    "create_enum"
    "drop_enum"
    "rename_enum"
    "add_enum_value"
    "rename_enum_value")))

; =============================================================================
; Extension and Schema Operations (PostgreSQL)
; =============================================================================

((call
  method: (identifier) @keyword.rails.schema
  (#any-of? @keyword.rails.schema
    "enable_extension"
    "disable_extension"
    "create_schema"
    "drop_schema")))

; =============================================================================
; Reversible and Safety
; =============================================================================

((call
  method: (identifier) @keyword.rails.schema
  (#any-of? @keyword.rails.schema
    "reversible"
    "up"
    "down"
    "revert"
    "safety_assured"
    "say"
    "say_with_time"
    "suppress_messages")))

; =============================================================================
; Data Operations
; =============================================================================

((call
  method: (identifier) @keyword.rails.schema
  (#any-of? @keyword.rails.schema
    "execute"
    "add_timestamps"
    "remove_timestamps")))

; =============================================================================
; View Operations (PostgreSQL)
; =============================================================================

((call
  method: (identifier) @keyword.rails.schema
  (#any-of? @keyword.rails.schema
    "create_view"
    "drop_view"
    "replace_view"
    "update_view")))

; =============================================================================
; Function and Trigger Operations (PostgreSQL)
; =============================================================================

((call
  method: (identifier) @keyword.rails.schema
  (#any-of? @keyword.rails.schema
    "create_function"
    "drop_function"
    "create_trigger"
    "drop_trigger")))

; =============================================================================
; ActiveRecord::Schema DSL
; =============================================================================

((call
  receiver: (scope_resolution
    name: (constant) @_schema
    (#eq? @_schema "Schema"))
  method: (identifier) @keyword.rails.schema
  (#eq? @keyword.rails.schema "define")))

; =============================================================================
; Migration Class Methods
; =============================================================================

((call
  method: (identifier) @function.macro.rails
  (#any-of? @function.macro.rails
    "disable_ddl_transaction"
    "disable_ddl_transaction!")))
