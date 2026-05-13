vim.opt.termguicolors = true

local function apply_bg()
	if not vim.g.colors_name or not vim.g.colors_name:match("^base16") then
		return
	end

	-- local bg = "#1E2426"
	local bg = "#222222"
	local hl = vim.api.nvim_set_hl

	hl(0, "Normal", { bg = bg })
	hl(0, "NormalNC", { bg = bg })
	hl(0, "EndOfBuffer", { bg = bg })
	hl(0, "SignColumn", { bg = bg })
	hl(0, "LineNr", { bg = bg })
	hl(0, "CursorLineNr", { bg = bg })
	hl(0, "FoldColumn", { bg = bg })

	hl(0, "SignColumn", { bg = bg })
	hl(0, "GitSignsAdd", { fg = "#99cc99", bg = bg })
	hl(0, "GitSignsChange", { fg = "#e6b450", bg = bg })
	hl(0, "GitSignsDelete", { fg = "#f2777a", bg = bg })
	hl(0, "GitSignsTopdelete", { fg = "#f2777a", bg = bg })
	hl(0, "GitSignsChangedelete", { fg = "#e6b450", bg = bg })

	hl(0, "DiagnosticError", { fg = "#E6A0A0" })
	hl(0, "DiagnosticWarn", { fg = "#E6D8A0" })

	hl(0, "DiagnosticVirtualTextError", { fg = "#E6A0A0" })
	hl(0, "DiagnosticVirtualTextWarn", { fg = "#E6D8A0" })

	hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = "#E6A0A0" })
	hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = "#E6D8A0" })
end

-- 1. Run AFTER any future colorscheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = apply_bg,
})

-- 2. Run ON STARTUP if a colorscheme is already loaded
apply_bg()
