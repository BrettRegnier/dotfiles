-- ~/.config/nvim/lua/plugins/ui.lua

return {

	-- Statusline
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local function get_short_cwd()
				return vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
			end

			require("lualine").setup({
				options = {
					theme = "auto",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					globalstatus = true,
				},
				sections = {
					lualine_a = {
						{
							"mode",
						},
					},
					lualine_b = {
						{
							"branch",
							icon = "",
						},
					},
					lualine_c = {
						{
							"diff",
							symbols = { added = "+", modified = "m", removed = "-" },
						},
						{
							"diagnostics",
							symbols = { error = "E ", warn = "W ", info = "I ", hint = "󰌵 " },
						},
					},
					lualine_x = {
						{
							"filetype",
							icon_only = true,
							padding = { left = 1, right = 0 },
						},
						{
							"filename",
							path = 0,
							symbols = { modified = "", readonly = "", unnamed = "" },
						},
					},
					lualine_y = {
						{ get_short_cwd },
					},
					lualine_z = {
						{
							"location",
							padding = { left = 0, right = 1 },
						},
					},
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
			})
		end,
	},
	-- Indent guides
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			indent = {
				char = "│",
				tab_char = "│",
			},
			scope = {
				enabled = true,
				show_start = true,
				show_end = false,
			},
			exclude = {
				filetypes = {
					"help",
					"alpha",
					"dashboard",
					"neo-tree",
					"Trouble",
					"lazy",
					"mason",
					"notify",
					"toggleterm",
					"lazyterm",
				},
			},
		},
	},
}
