return {
	"zaldih/themery.nvim",
	lazy = false,
	config = function()
		require("themery").setup({
			themes = { "base16-ashes", "base16-catppuccin-latte" },
			-- add the config here
		})
	end,
}
