-- ~/.config/nvim/lua/theme-sync.lua
--
-- Reads the same state file the Hyprland/Ghostty toggle script writes to,
-- and keeps Neovim in sync: colorscheme, WinSeparator, and (if you're in a
-- C/C++ buffer) the cpp pastel highlights -- on startup and while running.

local M = {}

local state_file = vim.fn.expand("~/.local/state/theme")
local color = require("custom.colour-utils")
local cpp_theme = require("custom.cpp-theme")

local DARK_COLORSCHEME = "base16-ashes"
local LIGHT_COLORSCHEME = "base16-catppuccin-latte"

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
	-- 1. Apply the Neovim background and colorscheme
	if mode == "light" then
		vim.o.background = "light"
		vim.cmd.colorscheme(LIGHT_COLORSCHEME)
	else
		vim.o.background = "dark"
		vim.cmd.colorscheme(DARK_COLORSCHEME)
	end

	-- 2. Apply WinSeparator colors based on the new Normal background
	local ok, normal = pcall(vim.api.nvim_get_hl, 0, { name = "Normal" })
	if ok and normal.bg then
		local bg_hex = string.format("#%06x", normal.bg)
		local sep = mode == "light" and color.darken(bg_hex, 0.15) or color.lighten(bg_hex, 0.20)
		vim.api.nvim_set_hl(0, "WinSeparator", { fg = sep })
	end

	-- 3. Apply C/C++ specific highlights
	local ft = vim.bo.filetype
	if ft == "cpp" or ft == "c" then
		cpp_theme.apply(mode)
	end

	-- 4. THE FIX: Ask Lazy to reload UI plugins so they fetch the fresh highlights
	-- while preserving your exact personal configurations.
	local has_loader, loader = pcall(require, "lazy.core.loader")
	local has_config, lazy_config = pcall(require, "lazy.core.config")

	if has_loader and has_config then
		local plugins_to_reload = {
			"nvim-web-devicons",
			"bufferline.nvim",
			"lualine.nvim",
			"neo-tree.nvim",
		}
		for _, plugin in ipairs(plugins_to_reload) do
			-- Only reload the plugin if Lazy says it is currently active
			if lazy_config.plugins[plugin] and lazy_config.plugins[plugin]._.loaded then
				loader.reload(plugin)
			end
		end
	end
end

apply(read_mode())

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

return M
