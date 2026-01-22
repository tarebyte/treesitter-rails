--- Configuration module for treesitter-rails
--- @module treesitter-rails.config

local M = {}

--- Default configuration
--- @type table
M.defaults = {
  --- Enable the plugin
  enabled = true,
  --- Highlight priority (higher than default treesitter at 100)
  priority = 125,
  --- Contexts to enable (nil means all)
  contexts = nil,
}

--- Current configuration (merged with defaults)
--- @type table
M.options = vim.deepcopy(M.defaults)

--- Highlight group definitions linking to standard treesitter captures
--- @type table<string, table>
M.highlights = {
  -- Associations (belongs_to, has_many, etc.)
  ['@function.macro.rails.association'] = { link = '@function.macro' },
  ['@function.macro.rails.association.ruby'] = { link = '@function.macro' },

  -- Validations
  ['@function.macro.rails.validation'] = { link = '@function.macro' },
  ['@function.macro.rails.validation.ruby'] = { link = '@function.macro' },

  -- Callbacks
  ['@function.macro.rails.callback'] = { link = '@function.macro' },
  ['@function.macro.rails.callback.ruby'] = { link = '@function.macro' },

  -- Attribute macros (attr_accessor, enum, etc.)
  ['@function.macro.rails.attribute'] = { link = '@function.macro' },
  ['@function.macro.rails.attribute.ruby'] = { link = '@function.macro' },

  -- Controller filters (before_action, after_action, etc.)
  ['@function.macro.rails.filter'] = { link = '@function.macro' },
  ['@function.macro.rails.filter.ruby'] = { link = '@function.macro' },

  -- Response methods (render, redirect_to, etc.)
  ['@keyword.rails.response'] = { link = '@keyword' },
  ['@keyword.rails.response.ruby'] = { link = '@keyword' },

  -- Controller helpers (params, request, session, etc.)
  ['@variable.builtin.rails'] = { link = '@variable.builtin' },
  ['@variable.builtin.rails.ruby'] = { link = '@variable.builtin' },

  -- View helpers (form_for, link_to, etc.)
  ['@function.rails.helper'] = { link = '@function.builtin' },
  ['@function.rails.helper.ruby'] = { link = '@function.builtin' },

  -- Route DSL (resources, namespace, get, etc.)
  ['@keyword.rails.route'] = { link = '@keyword' },
  ['@keyword.rails.route.ruby'] = { link = '@keyword' },

  -- Schema methods (create_table, add_column, etc.)
  ['@keyword.rails.schema'] = { link = '@keyword' },
  ['@keyword.rails.schema.ruby'] = { link = '@keyword' },

  -- Test assertions
  ['@function.rails.assertion'] = { link = '@function.builtin' },
  ['@function.rails.assertion.ruby'] = { link = '@function.builtin' },

  -- Test macros (describe, it, let, etc.)
  ['@function.macro.rails.test'] = { link = '@function.macro' },
  ['@function.macro.rails.test.ruby'] = { link = '@function.macro' },

  -- Job macros (queue_as, retry_on, etc.)
  ['@function.macro.rails.job'] = { link = '@function.macro' },
  ['@function.macro.rails.job.ruby'] = { link = '@function.macro' },

  -- Mailer macros
  ['@function.macro.rails.mailer'] = { link = '@function.macro' },
  ['@function.macro.rails.mailer.ruby'] = { link = '@function.macro' },

  -- Generic Rails macro (ActiveSupport extensions)
  ['@function.macro.rails'] = { link = '@function.macro' },
  ['@function.macro.rails.ruby'] = { link = '@function.macro' },
}

--- Setup highlight groups
function M.setup_highlights()
  for group, definition in pairs(M.highlights) do
    vim.api.nvim_set_hl(0, group, definition)
  end
end

--- Merge user options with defaults
--- @param opts table|nil User options
function M.setup(opts)
  M.options = vim.tbl_deep_extend('force', vim.deepcopy(M.defaults), opts or {})
  M.setup_highlights()
end

return M
