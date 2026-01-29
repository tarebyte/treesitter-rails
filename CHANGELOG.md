# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-01-29

### Added

- Initial public release
- Context-aware syntax highlighting for Rails projects
- Support for multiple Rails contexts:
  - **Models**: associations, validations, callbacks, scopes, enums, attribute macros
  - **Controllers**: filters, response methods, strong parameters, helpers
  - **Views**: form helpers, URL helpers, asset helpers, content helpers
  - **Migrations**: schema DSL, table/column operations, indexes, constraints
  - **Routes**: HTTP verbs, resources, namespaces, concerns
  - **Jobs**: ActiveJob configuration, callbacks, queue settings
  - **Mailers**: mail configuration, delivery methods, attachments
  - **Tests**: Minitest assertions and RSpec DSL
- Common ActiveSupport patterns applied to all Rails contexts:
  - Time helpers (`1.day.ago`, `2.hours.from_now`)
  - Byte helpers (`5.megabytes`)
  - Delegation (`delegate`, `delegate_missing_to`)
  - Class attributes (`class_attribute`, `cattr_accessor`)
  - Concern DSL (`included`, `class_methods`)
- Packwerk/packs support for modular Rails monoliths
- Tree-sitter queries in `.scm` files for editor syntax highlighting
- Vim help documentation (`:help treesitter-rails`)
- Commands:
  - `:TSRailsEnable` / `:TSRailsDisable` / `:TSRailsToggle`
  - `:TSRailsRefresh` - Refresh current buffer
  - `:TSRailsInfo` - Show plugin status
  - `:TSRailsContext` - Show detected context
  - `:TSRailsReload` - Reload queries (development)
  - `:TSRailsInspect` - Inspect captures at cursor
- Lua API for programmatic control
- Configurable highlight priority (default 125)
- Option to enable only specific contexts
- GitHub Actions CI (tests on Neovim stable/nightly, luacheck, StyLua)

[0.1.0]: https://github.com/tarebyte/treesitter-rails/releases/tag/v0.1.0
