-- ~/.config/nvim/lua/theme-sync.lua
--
-- Reads the same state file the Hyprland/Ghostty toggle script writes to,
-- and keeps Neovim in sync: colorscheme, WinSeparator, and (if you're in a
-- C/C++ buffer) the cpp pastel highlights -- on startup and while running.

local M = {}

local state_file = vim.fn.expand("~/.local/state/theme")
local color = require("custom.helpers")
local cpp_theme = require("custom.cpp-theme")

local DARK_COLORSCHEME = "base16-ashes"
local LIGHT_COLORSCHEME = "catppuccin-latte"

local function read_mode()
  local f = io.open(state_file, "r")
  if not f then
    return "dark"
  end
  local mode = f:read("*l")
  f:close()
  return mode or "dark"
end

local function apply(mode)
  if mode == "light" then
    vim.o.background = "light"
    vim.cmd.colorscheme(LIGHT_COLORSCHEME)
  else
    vim.o.background = "dark"
    vim.cmd.colorscheme(DARK_COLORSCHEME)
  end

  local ok, normal = pcall(vim.api.nvim_get_hl, 0, { name = "Normal" })
  if ok and normal.bg then
    local bg_hex = string.format("#%06x", normal.bg)
    local sep = mode == "light" and color.darken(bg_hex, 0.15) or color.lighten(bg_hex, 0.20)
    vim.api.nvim_set_hl(0, "WinSeparator", { fg = sep })
  end

  local ft = vim.bo.filetype
  if ft == "cpp" or ft == "c" then
    cpp_theme.apply(mode)
  end
end

function M.setup()
  apply(read_mode())

  local uv = vim.uv or vim.loop
  local last_mtime

  -- Reapply everything when you refocus/re-enter Neovim after toggling
  -- theme externally (e.g. via the Hyprland keybind).
  vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "TermEnter" }, {
    callback = function()
      local stat = uv.fs_stat(state_file)
      if stat and stat.mtime.sec ~= last_mtime then
        last_mtime = stat.mtime.sec
        apply(read_mode())
      end
    end,
  })

  -- Separately: whenever you enter/open a C/C++ buffer, make sure the cpp
  -- pastel highlights match the *current* mode. Covers both "first time
  -- opening a cpp file this session" and "toggled theme while already in
  -- one". This replaces the need for after/ftplugin/cpp.lua entirely.
  vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
    callback = function()
      local ft = vim.bo.filetype
      if ft == "cpp" or ft == "c" then
        cpp_theme.apply(read_mode())
      end
    end,
  })
end

-- return M
