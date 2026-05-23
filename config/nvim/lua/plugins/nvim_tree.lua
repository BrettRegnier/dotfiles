-- File explorer

-- TODO move into a helper file
local helpers = require("../custom/helpers")
local M = {
	"nvim-tree/nvim-tree.lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	cmd = { "NvimTreeToggle", "NvimTreeFocus" },
	keys = {
		{ "<C-n>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file explorer" },
		{ "<leader>e", "<cmd>NvimTreeFocus<CR>", desc = "Focus file explorer" },
	},
	config = function()
		local function on_attach(bufnr)
			local api = require("nvim-tree.api")

			local function opts(desc)
				return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
			end

			-- Default mappings
			api.config.mappings.default_on_attach(bufnr)

			-- Remove the 'f' mapping for filter
			vim.keymap.del("n", "f", { buffer = bufnr })

			-- Optionally, remap filter to a different key like 'F' or '<leader>f'
			vim.keymap.set("n", "F", api.live_filter.start, opts("Filter"))
		end

		require("nvim-tree").setup({
			disable_netrw = true,
			hijack_netrw = true,
			on_attach = on_attach,
			view = {
				width = 30,
			},
			renderer = {
				indent_markers = {
					enable = true,
				},
				icons = {
					show = {
						file = true,
						folder = true,
						folder_arrow = true,
						git = true,
					},
				},
				root_folder_label = false,
			},
			filters = {
				dotfiles = false,
			},
			git = {
				enable = true,
				ignore = false,
			},
		})
	end,
}

vim.api.nvim_create_autocmd("FileType", {
	pattern = "NvimTree",
	callback = function()
		local bg = vim.api.nvim_get_hl_by_name("Normal", true).background or 0x1e1e2e
		vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = helpers.darken(bg, 0.15) })
		vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { bg = helpers.darken(bg, 0.15) })
	end,
})

return M
