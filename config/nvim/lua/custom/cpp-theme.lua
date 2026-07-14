-- ~/.config/nvim/lua/custom/cpp-theme.lua
--
-- Your pastel semantic highlighting from cpp.lua, made mode-aware.
-- theme-sync.lua calls M.apply(mode) whenever you enter a C/C++ buffer, and
-- again if you toggle theme while already sitting in one.

local color = require("custom.colour-utils")

local M = {}

-- Original dark-mode hues (against background #1E2426) -- single source of
-- truth; light mode reuses the same hues, darkened for a light background.
local palette = {
	namespace = "#C6A7B2",
	type = "#D1C4EE",
	fn = "#6FAEB8",
	fn_call = "#7FBAC8",
	macro = "#9FBFD9",
	variable = "#8FB7A1",
	parameter = "#9FBDB0",
	variable_builtin = "#739B86",
	enum_member = "#E3B3A3",
	keyword = "#E2A1A1",
	operator = "#7FAFB0",
	type_pale = "#CBD6F4",
	number = "#E6C58F",
	string = "#F0B36A",
	string_special = "#C9B48A",
	comment = "#8F9EA3",
}

-- Tune this once you see it against Catppuccin Latte's background.
local LIGHT_DARKEN = 0.4

function M.apply(mode)
	local hl = vim.api.nvim_set_hl
	local function c(key)
		return mode == "light" and color.darken(palette[key], LIGHT_DARKEN) or palette[key]
	end

	hl(0, "@lsp.type.namespace", { fg = c("namespace") })
	hl(0, "@lsp.type.type", { fg = c("type"), bold = true })
	hl(0, "@lsp.type.enum", { fg = c("type"), bold = true })
	hl(0, "@lsp.type.function", { fg = c("fn") })
	hl(0, "@lsp.type.method", { fg = c("fn") })
	hl(0, "@lsp.type.macro", { fg = c("macro") })
	hl(0, "@lsp.type.variable", { fg = c("variable"), bold = true })
	hl(0, "@lsp.type.parameter", { fg = c("parameter") })
	hl(0, "@lsp.type.enumMember", { fg = c("enum_member"), bold = true })
	hl(0, "@lsp.type.enumMember.cpp", { fg = c("enum_member"), bold = true })

	hl(0, "@keyword", { fg = c("keyword") })
	hl(0, "@keyword.type", { fg = c("type"), bold = true })
	hl(0, "@operator", { fg = c("operator") })

	hl(0, "@function", { fg = c("fn") })
	hl(0, "@function.call", { fg = c("fn_call") })

	hl(0, "@type", { fg = c("type_pale"), bold = true })
	hl(0, "@type.builtin", { fg = c("type"), bold = true })
	hl(0, "@namespace", { fg = c("namespace") })

	hl(0, "@variable", { fg = c("variable"), bold = true })
	hl(0, "@variable.parameter", { fg = c("parameter") })
	hl(0, "@variable.builtin", { fg = c("variable_builtin"), bold = true })

	hl(0, "@number", { fg = c("number") })
	hl(0, "@constant", { fg = c("number") })

	hl(0, "@string", { fg = c("string") })
	hl(0, "@string.special", { fg = c("string_special"), italic = true })
	hl(0, "@string.special.path", { fg = c("string_special"), italic = true })

	hl(0, "@enumMember", { fg = c("enum_member"), bold = true })

	hl(0, "@comment", { fg = c("comment"), italic = true })
end

return M
