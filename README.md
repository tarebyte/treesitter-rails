# treesitter-rails

Rails-specific Tree-sitter syntax highlighting for Neovim.

This plugin provides context-aware highlighting for Rails projects by detecting file types (models, controllers, views, etc.) and applying appropriate Tree-sitter queries to highlight Rails DSL methods, macros, and patterns.

## Features

- **Context-aware highlighting** - Different highlighting based on file location (models, controllers, views, etc.)
- **Comprehensive Rails DSL coverage**:
  - **Models**: associations, validations, callbacks, scopes, enums, attribute macros
  - **Controllers**: filters, response methods, strong parameters, helpers
  - **Views**: form helpers, URL helpers, asset helpers, content helpers
  - **Migrations**: schema DSL, table/column operations, indexes, constraints
  - **Routes**: HTTP verbs, resources, namespaces, concerns
  - **Jobs**: ActiveJob configuration, callbacks, queue settings
  - **Mailers**: mail configuration, delivery methods, attachments
  - **Tests**: Minitest assertions and RSpec DSL
- **Global ActiveSupport patterns** - Time helpers, byte helpers, delegation, class attributes
- **High performance** - Uses Neovim's decoration provider API with ephemeral extmarks
- **Configurable** - Enable/disable specific contexts, adjust highlight priority

## Requirements

- Neovim 0.9+
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) with Ruby parser installed

## Installation

### lazy.nvim

```lua
{
  'tarebyte/treesitter-rails',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  ft = 'ruby',
  config = function()
    require('treesitter-rails').setup()
  end,
}
```

### packer.nvim

```lua
use {
  'tarebyte/treesitter-rails',
  requires = { 'nvim-treesitter/nvim-treesitter' },
  ft = 'ruby',
  config = function()
    require('treesitter-rails').setup()
  end,
}
```

### vim-plug

```vim
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'tarebyte/treesitter-rails'

" In your init.lua or after/plugin:
lua require('treesitter-rails').setup()
```

## Configuration

```lua
require('treesitter-rails').setup({
  -- Enable/disable the plugin (default: true)
  enabled = true,

  -- Highlight priority, higher than default treesitter (100)
  -- Increase if highlights are being overridden
  priority = 125,

  -- Contexts to enable (nil means all contexts)
  -- Available: 'model', 'controller', 'view', 'migration', 'routes',
  --            'job', 'mailer', 'minitest', 'rspec'
  contexts = nil,
})
```

### Example: Enable only specific contexts

```lua
require('treesitter-rails').setup({
  contexts = { 'model', 'controller', 'view' },
})
```

## Commands

| Command | Description |
|---------|-------------|
| `:TreesitterRailsEnable` | Enable highlighting |
| `:TreesitterRailsDisable` | Disable highlighting |
| `:TreesitterRailsToggle` | Toggle highlighting on/off |
| `:TreesitterRailsRefresh` | Refresh highlighting for current buffer |
| `:TreesitterRailsInfo` | Show plugin status and attached buffers |
| `:TreesitterRailsContext` | Show detected context for current buffer |
| `:TreesitterRailsReload` | Reload queries (for development) |

## Context Detection

Files are assigned contexts based on their path:

| Path Pattern | Context |
|--------------|---------|
| `app/models/**/*.rb` | `model` |
| `app/controllers/**/*.rb` | `controller` |
| `app/views/**/*` | `view` |
| `app/helpers/**/*.rb` | `view` |
| `app/jobs/**/*.rb` | `job` |
| `app/mailers/**/*.rb` | `mailer` |
| `db/migrate/**/*.rb` | `migration` |
| `db/schema.rb` | `migration` |
| `config/routes.rb` | `routes` |
| `config/routes/**/*.rb` | `routes` |
| `test/**/*_test.rb` | `minitest` |
| `spec/**/*_spec.rb` | `rspec` |

## Highlight Groups

The plugin defines semantic highlight groups that link to standard Tree-sitter captures:

| Group | Links To | Used For |
|-------|----------|----------|
| `@function.macro.rails.association` | `@function.macro` | `belongs_to`, `has_many`, etc. |
| `@function.macro.rails.validation` | `@function.macro` | `validates`, `validates_presence_of`, etc. |
| `@function.macro.rails.callback` | `@function.macro` | `before_save`, `after_create`, etc. |
| `@function.macro.rails.attribute` | `@function.macro` | `enum`, `scope`, `serialize`, etc. |
| `@function.macro.rails.filter` | `@function.macro` | `before_action`, `after_action`, etc. |
| `@keyword.rails.response` | `@keyword` | `render`, `redirect_to`, etc. |
| `@variable.builtin.rails` | `@variable.builtin` | `params`, `request`, `session`, etc. |
| `@function.rails.helper` | `@function.builtin` | `link_to`, `form_with`, URL helpers, etc. |
| `@keyword.rails.route` | `@keyword` | `resources`, `get`, `namespace`, etc. |
| `@keyword.rails.schema` | `@keyword` | `create_table`, `add_column`, etc. |
| `@function.rails.assertion` | `@function.builtin` | `assert_equal`, `expect`, etc. |
| `@function.macro.rails.test` | `@function.macro` | `describe`, `it`, `let`, etc. |

### Customizing Highlights

Override the default links in your colorscheme or config:

```lua
vim.api.nvim_set_hl(0, '@function.macro.rails.association', { fg = '#e06c75', bold = true })
vim.api.nvim_set_hl(0, '@function.macro.rails.callback', { link = 'Special' })
```

## API

```lua
local rails = require('treesitter-rails')

-- Enable/disable
rails.enable()
rails.disable()
rails.toggle()
rails.is_enabled()

-- Get context for current or specific buffer
rails.get_context()
rails.get_context(bufnr)

-- Refresh highlighting
rails.refresh()

-- Get available contexts
rails.contexts()  -- { 'model', 'controller', 'view', ... }

-- Get status info
rails.status()  -- { enabled, priority, contexts, attached_buffers }
rails.info()    -- Prints status to messages
```

## How It Works

1. On `FileType ruby`, the plugin detects the Rails context from the file path
2. Loads the appropriate Tree-sitter query for that context
3. Registers a decoration provider that applies highlights to the visible range
4. Uses ephemeral extmarks with configurable priority (default 125, above treesitter's 100)

The decoration provider approach means:
- Only visible lines are processed (efficient for large files)
- Highlights update automatically on scroll and edit
- No persistent extmarks cluttering the buffer

## Comparison with vim-rails

This plugin focuses specifically on syntax highlighting, complementing vim-rails rather than replacing it. vim-rails provides navigation, generators, and other Rails-specific functionality that this plugin does not attempt to replicate.

| Feature | treesitter-rails | vim-rails |
|---------|------------------|-----------|
| Syntax highlighting | Tree-sitter based, context-aware | Regex-based |
| Navigation (`:Emodel`, etc.) | No | Yes |
| Generators (`:Rails`) | No | Yes |
| Projections | No | Yes |
| Performance | O(visible lines) | O(file size) |

## Development

### Reloading queries

During development, use `:TreesitterRailsReload` to reload all query modules without restarting Neovim.

### Adding new patterns

1. Identify the context (model, controller, etc.)
2. Edit the corresponding query file in `lua/treesitter-rails/queries/`
3. Use Tree-sitter query syntax with the plugin's capture naming convention
4. Test with `:TreesitterRailsReload`

### Testing queries

Use `:InspectTree` (Neovim 0.9+) to see the Tree-sitter AST for the current buffer and craft appropriate queries.

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

## License

Distributed under the same terms as Vim itself. See [LICENSE](LICENSE).

This project is based on highlighting patterns from [vim-rails](https://github.com/tpope/vim-rails) by Tim Pope.
