# treesitter-rails

[![Neovim](https://img.shields.io/badge/Neovim-0.9+-blueviolet.svg?logo=neovim)](https://neovim.io)
[![License](https://img.shields.io/badge/License-Vim-green.svg)](LICENSE)

**Context-aware Rails syntax highlighting for Neovim**, powered by Tree-sitter.

The plugin detects where you are in a Rails project (model, controller, view, etc.) and highlights Rails-specific DSL methods, macros, and patterns accordingly.

## Quick Start

**1. Install with lazy.nvim:**

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

**2. That's it!** Open a Rails file and see the highlighting.

## What Gets Highlighted

| Context | Examples |
|---------|----------|
| **Models** | `belongs_to`, `has_many`, `validates`, `before_save`, `scope`, `enum` |
| **Controllers** | `before_action`, `render`, `redirect_to`, `params`, `session` |
| **Views** | `link_to`, `form_with`, `content_for`, `image_tag`, URL helpers |
| **Migrations** | `create_table`, `add_column`, `add_index`, `t.string`, `t.references` |
| **Routes** | `resources`, `get`, `post`, `namespace`, `root` |
| **Jobs** | `queue_as`, `retry_on`, `perform_later` |
| **Mailers** | `mail`, `default`, `attachments`, `deliver_later` |
| **Tests** | `describe`, `it`, `let`, `expect`, `assert_equal` |

Plus **ActiveSupport patterns** everywhere: `1.day.ago`, `delegate`, `class_attribute`, and more.

## Requirements

- Neovim 0.9+
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) with Ruby parser (`TSInstall ruby`)

## Installation

<details>
<summary><strong>lazy.nvim</strong> (recommended)</summary>

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
</details>

<details>
<summary><strong>packer.nvim</strong></summary>

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
</details>

<details>
<summary><strong>vim-plug</strong></summary>

```vim
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'tarebyte/treesitter-rails'
```

Then in your config:
```lua
require('treesitter-rails').setup()
```
</details>

## Commands

| Command | Description |
|---------|-------------|
| `:TSRailsEnable` | Enable highlighting |
| `:TSRailsDisable` | Disable highlighting |
| `:TSRailsToggle` | Toggle on/off |
| `:TSRailsContext` | Show detected context for current file |
| `:TSRailsInfo` | Show plugin status |
| `:TSRailsInspect` | Debug: show captures at cursor |

## Configuration

The defaults work for most users. Customize if needed:

```lua
require('treesitter-rails').setup({
  -- Highlight priority (increase if highlights are being overridden)
  priority = 125,

  -- Only enable specific contexts (nil = all)
  contexts = { 'model', 'controller', 'view' },
})
```

## How Context Detection Works

The plugin determines context from your file path:

| Path | Context |
|------|---------|
| `app/models/**/*.rb` | model |
| `app/controllers/**/*.rb` | controller |
| `app/views/**/*` | view |
| `app/helpers/**/*.rb` | view |
| `app/jobs/**/*.rb` | job |
| `app/mailers/**/*.rb` | mailer |
| `db/migrate/**/*.rb` | migration |
| `config/routes.rb` | routes |
| `spec/**/*_spec.rb` | rspec |
| `test/**/*_test.rb` | minitest |

**Works with modular Rails!** Packwerk, engines, and packs are supported:

```
packs/billing/app/models/invoice.rb     → model
engines/payments/app/controllers/*.rb   → controller
```

## Customizing Highlight Colors

All highlights link to standard Tree-sitter groups by default. Override them in your config:

```lua
-- Make associations stand out
vim.api.nvim_set_hl(0, '@function.macro.rails.association', {
  fg = '#e06c75',
  bold = true
})

-- Use a different group for callbacks
vim.api.nvim_set_hl(0, '@function.macro.rails.callback', {
  link = 'Special'
})
```

<details>
<summary><strong>All highlight groups</strong></summary>

| Group | Default Link | Used For |
|-------|--------------|----------|
| `@function.macro.rails.association` | `@function.macro` | `belongs_to`, `has_many` |
| `@function.macro.rails.validation` | `@function.macro` | `validates`, etc. |
| `@function.macro.rails.callback` | `@function.macro` | `before_save`, etc. |
| `@function.macro.rails.attribute` | `@function.macro` | `enum`, `scope` |
| `@function.macro.rails.filter` | `@function.macro` | `before_action` |
| `@keyword.rails.response` | `@keyword` | `render`, `redirect_to` |
| `@variable.builtin.rails` | `@variable.builtin` | `params`, `session` |
| `@function.rails.helper` | `@function.builtin` | `link_to`, `form_with` |
| `@keyword.rails.route` | `@keyword` | `resources`, `get` |
| `@keyword.rails.schema` | `@keyword` | `create_table` |
| `@function.rails.assertion` | `@function.builtin` | `assert_equal`, `expect` |
| `@function.macro.rails.test` | `@function.macro` | `describe`, `it`, `let` |

</details>

## Works Great With

- **[vim-rails](https://github.com/tpope/vim-rails)** - Navigation, generators, and more (this plugin complements it)
- **[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)** - Required for Tree-sitter support

## Documentation

Full documentation available via `:help treesitter-rails`

## Contributing

Contributions welcome! Feel free to open issues or submit PRs.

### Development

```bash
# Run tests
./tests/run.sh

# Reload queries without restarting Neovim
:TSRailsReload

# See the Tree-sitter AST for crafting queries
:InspectTree
```

## License

Distributed under the same terms as Vim itself. See [LICENSE](LICENSE).

Highlighting patterns inspired by [vim-rails](https://github.com/tpope/vim-rails) by Tim Pope.
