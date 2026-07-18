-- ~/.config/nvim/lua/theme-sync.lua
--
-- Reads the same state file the Hyprland/Ghostty toggle script writes to,
-- and keeps Neovim in sync: colorscheme, WinSeparator, and (if you're in a
-- C/C++ buffer) the cpp pastel highlights -- on startup and while running.

local state_file = vim.fn.expand("~/.local/state/theme")
local color = require("custom.colour-utils")
local cpp_theme = require("custom.cpp-theme")

local DARK_COLORSCHEME = "base16-ashes"
local LIGHT_COLORSCHEME = "base16-catppuccin-latte"

local themery = require("themery")

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
		themery.setThemeByName(LIGHT_COLORSCHEME)
	else
		themery.setThemeByName(DARK_COLORSCHEME)
	end
end

local function theme_selector()
	apply(read_mode())
end

local function cpp_theme_selector()
	local ft = vim.bo.filetype
	if ft == "cpp" or ft == "c" then
		cpp_theme.apply(read_mode())
	end
end

-- Reapply everything when you refocus/re-enter Neovim after toggling
-- theme externally (e.g. via the Hyprland keybind).
-- vim.api.nvim_create_autocmd({ "BufEnter", "TermEnter" }, {
-- 	callback = theme_selector,
-- })

-- Separately: whenever you enter/open a C/C++ buffer, make sure the cpp
-- pastel highlights match the *current* mode. Covers both "first time
-- opening a cpp file this session" and "toggled theme while already in
-- one". This replaces the need for after/ftplugin/cpp.lua entirely.
vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
	callback = cpp_theme_selector,
})

-- Define a custom autocommand
vim.api.nvim_create_autocmd("User", {
	pattern = "GlobalNotify",
	callback = function()
		vim.notify("Received notification theme update", vim.log.levels.INFO)
		theme_selector()
	end,
})

apply(read_mode())
