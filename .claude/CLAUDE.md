# treesitter-rails

A Neovim plugin that provides Rails-specific Tree-sitter syntax highlighting.

## Project Structure

```
treesitter-rails/
├── doc/
│   └── treesitter-rails.txt  # Vim help documentation
├── lua/treesitter-rails/
│   ├── init.lua           # Main module, setup, enable/disable
│   ├── config.lua         # Configuration and highlight group definitions
│   ├── context.lua        # File path → context detection
│   ├── highlight.lua      # Decoration provider implementation
│   └── queries/
│       └── init.lua       # Query loading and caching
├── queries/               # Tree-sitter query files (.scm)
│   ├── common.scm         # Patterns for all Rails contexts
│   ├── model.scm          # Model-specific patterns
│   ├── controller.scm     # Controller-specific patterns
│   ├── view.scm           # View/helper-specific patterns
│   ├── migration.scm      # Migration/schema patterns
│   ├── routes.scm         # Routes DSL patterns
│   ├── job.scm            # ActiveJob patterns
│   ├── mailer.scm         # ActionMailer patterns
│   ├── minitest.scm       # Minitest patterns
│   └── rspec.scm          # RSpec patterns
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

Each context has a `.scm` file in the `queries/` directory containing Tree-sitter query patterns. Queries are read from disk and parsed once, then cached.

**Important**: The `common.scm` query is applied to ALL Rails contexts in addition to context-specific queries. It contains ActiveSupport patterns like time helpers, delegation, etc.

## Development Guidelines

### Adding New Patterns

1. Identify the appropriate context (model, controller, etc.)
2. Edit the corresponding file in `queries/` (e.g., `queries/model.scm`)
3. Use Tree-sitter query syntax with the naming convention:
   - `@function.macro.rails.*` for DSL macros
   - `@keyword.rails.*` for keyword-like methods
   - `@variable.builtin.rails` for built-in variables
   - `@function.rails.helper` for helper methods
4. Test with `:TSRailsReload`

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

The `common.scm` query should NOT include patterns for standard Ruby methods:

- ❌ `include`, `extend`, `prepend` (standard Ruby)
- ❌ `autoload` (standard Ruby)
- ✅ `delegate`, `delegate_missing_to` (ActiveSupport)
- ✅ `class_attribute`, `cattr_accessor` (ActiveSupport)
- ✅ `extend ActiveSupport::Concern` (specific pattern is OK)

## Commands

| Command | Description |
|---------|-------------|
| `:TSRailsEnable` | Enable highlighting |
| `:TSRailsDisable` | Disable highlighting |
| `:TSRailsToggle` | Toggle highlighting |
| `:TSRailsRefresh` | Refresh current buffer |
| `:TSRailsInfo` | Show status |
| `:TSRailsContext` | Show detected context |
| `:TSRailsReload` | Reload queries (dev) |
| `:TSRailsInspect` | Inspect captures at cursor |

## Highlight Groups

All groups link to standard treesitter captures by default:

| Group | Links To |
|-------|----------|
| `@function.macro.rails.*` | `@function.macro` |
| `@keyword.rails.*` | `@keyword` |
| `@variable.builtin.rails` | `@variable.builtin` |
| `@function.rails.*` | `@function.builtin` |
