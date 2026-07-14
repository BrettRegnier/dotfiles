-- ~/.config/nvim/lua/plugins/colour_scheme.lua

local helpers = require("../custom/helpers")

return {
	{
		"RRethy/base16-nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("base16-colorscheme").with_config({
				telescope = true,
				indentblankline = true,
				notify = true,
				ts_rainbow = true,
				cmp = true,
				illuminate = true,
			})

			-- vim.cmd.colorscheme("base16-ashes")
			-- local bg = vim.api.nvim_get_hl_by_name("Normal", true).background
			-- vim.api.nvim_set_hl(0, "WinSeparator", { fg = helpers.lighten(bg, 0.20) })
		end,
	},
}
