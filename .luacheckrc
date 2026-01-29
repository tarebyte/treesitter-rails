-- Luacheck configuration for Neovim plugins
std = "luajit"
cache = true

-- Neovim globals
read_globals = {
  "vim",
}

-- Ignore some warnings
ignore = {
  "212", -- Unused argument (common in callbacks)
  "631", -- Line too long
}

-- Project-specific settings
files["tests/**/*.lua"] = {
  ignore = {
    "111", -- Setting non-standard global (test helpers)
    "112", -- Mutating non-standard global
    "113", -- Accessing undefined global
  }
}
