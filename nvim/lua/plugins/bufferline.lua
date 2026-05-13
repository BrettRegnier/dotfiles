-- Bufferline
local helpers = require("../custom/helpers")
local bg = vim.api.nvim_get_hl_by_name("Normal", true).background

local M = {
	{
		"famiu/bufdelete.nvim",
		event = "VeryLazy",
	},
	{

		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{ "<Tab>", "<cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
			{ "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", desc = "Previous buffer" },
			{ "<leader>x", "<cmd>Bdelete<CR>", desc = "Close buffer" },
		},
		config = function()
			require("bufferline").setup({
				options = {
					-- TODO if the last buffer is closed, go back to dashboard
					close_command = require("bufdelete").bufdelete,
					mode = "buffers",
					themeable = true,
					numbers = "none",
					separator_style = "none",
					always_show_bufferline = true,
					show_buffer_close_icons = false,
					show_close_icon = false,
					color_icons = true,
					offsets = {
						{
							filetype = "NvimTree",
							-- highlight = "Directory",
							text_align = "left",
							separator = true,
						},
					},
					custom_filter = function(buff_number)
						local name = vim.fn.bufname(buff_number)
						print(name)
						if name:match("NvimTree") then
							return false
						end

						return true
					end,
				},
				highlights = {
					fill = {
						bg = helpers.lighten(bg, 0.09),
					},
				},
			})
		end,
	},
}
return M
