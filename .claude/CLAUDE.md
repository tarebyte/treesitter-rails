# treesitter-rails

A Neovim plugin that provides Rails-specific Tree-sitter syntax highlighting.

## Project Structure

```
treesitter-rails/
├── lua/treesitter-rails/
│   ├── init.lua           # Main module, setup, enable/disable
│   ├── config.lua         # Configuration and highlight group definitions
│   ├── context.lua        # File path → context detection
│   ├── highlight.lua      # Decoration provider implementation
│   └── queries/
│       ├── init.lua       # Query loading and caching
│       ├── common.lua     # Patterns for all Rails contexts
│       ├── model.lua      # Model-specific patterns
│       ├── controller.lua # Controller-specific patterns
│       ├── view.lua       # View/helper-specific patterns
│       ├── migration.lua  # Migration/schema patterns
│       ├── routes.lua     # Routes DSL patterns
│       ├── job.lua        # ActiveJob patterns
│       ├── mailer.lua     # ActionMailer patterns
│       └── test.lua       # Minitest and RSpec patterns
├── plugin/
│   └── treesitter-rails.lua  # Auto-setup and user commands
├── tests/
│   ├── run.sh             # Test runner script
│   ├── context_spec.lua   # Context detection tests
│   ├── queries_spec.lua   # Query loading tests
│   └── common_patterns_spec.lua  # Common query pattern tests
└── README.md
```

## Architecture

### Decoration Provider

The plugin uses Neovim's decoration provider API (`nvim_set_decoration_provider`) to apply highlighting. This approach:

- Only processes visible lines (efficient for large files)
- Uses ephemeral extmarks (no persistent state)
- Applies with priority 125 (above treesitter's default 100)

### Context Detection

Files are assigned contexts based on path patterns. The detection looks for patterns **anywhere** in the path, supporting:

- Standard Rails: `app/models/user.rb`
- Packwerk/packs: `packs/billing/app/models/invoice.rb`
- Engines: `engines/payments/app/models/transaction.rb`

### Query System

Each context has a Lua module that returns a Tree-sitter query string. Queries are parsed and cached on first use.

**Important**: The `common.lua` query is applied to ALL Rails contexts in addition to context-specific queries. It contains ActiveSupport patterns like time helpers, delegation, etc.

## Development Guidelines

### Adding New Patterns

1. Identify the appropriate context (model, controller, etc.)
2. Edit the corresponding file in `lua/treesitter-rails/queries/`
3. Use Tree-sitter query syntax with the naming convention:
   - `@function.macro.rails.*` for DSL macros
   - `@keyword.rails.*` for keyword-like methods
   - `@variable.builtin.rails` for built-in variables
   - `@function.rails.helper` for helper methods
4. Test with `:TreesitterRailsReload`

### Testing Queries

Use `:InspectTree` to see the Tree-sitter AST and craft queries:

```lua
-- Common patterns:
((call
  method: (identifier) @function.macro.rails
  (#any-of? @function.macro.rails "belongs_to" "has_many")))
```

### Running Tests

```bash
./tests/run.sh
```

### Avoiding Conflicts with treesitter-ruby

The plugin is designed to layer ON TOP of treesitter-ruby, not conflict with it:

1. **No `after/queries/ruby/` files** - These would apply globally to all Ruby files
2. **Context-aware application** - Patterns only apply in detected Rails contexts
3. **Higher priority** - Uses priority 125 vs treesitter's 100
4. **No standard Ruby patterns** - Don't highlight `include`, `extend`, `prepend`, `autoload` as Rails-specific

### Common Query Restrictions

The `common.lua` query should NOT include patterns for standard Ruby methods:

- ❌ `include`, `extend`, `prepend` (standard Ruby)
- ❌ `autoload` (standard Ruby)
- ✅ `delegate`, `delegate_missing_to` (ActiveSupport)
- ✅ `class_attribute`, `cattr_accessor` (ActiveSupport)
- ✅ `extend ActiveSupport::Concern` (specific pattern is OK)

## Commands

| Command | Description |
|---------|-------------|
| `:TreesitterRailsEnable` | Enable highlighting |
| `:TreesitterRailsDisable` | Disable highlighting |
| `:TreesitterRailsToggle` | Toggle highlighting |
| `:TreesitterRailsRefresh` | Refresh current buffer |
| `:TreesitterRailsInfo` | Show status |
| `:TreesitterRailsContext` | Show detected context |
| `:TreesitterRailsReload` | Reload queries (dev) |

## Highlight Groups

All groups link to standard treesitter captures by default:

| Group | Links To |
|-------|----------|
| `@function.macro.rails.*` | `@function.macro` |
| `@keyword.rails.*` | `@keyword` |
| `@variable.builtin.rails` | `@variable.builtin` |
| `@function.rails.*` | `@function.builtin` |
