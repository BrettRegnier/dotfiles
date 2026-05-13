-- ~/.config/nvim/lua/plugins/telescope.lua
local helpers = require("custom/helpers")

local function SaveFolder(path)
	local home = os.getenv("HOME") or os.getenv("USERPROFILE")
	local data = {}

	-- TODO windows
	local file = io.open(home .. "/.local/share/nvim/folders.txt", "r")

	if file then
		-- Read if the file exists, otherwise we will just write to it.
		while true do
			local line = file:read("*l")
			if not line then
				break
			end
			-- Only read in 9
			if #data >= 9 then
				break
			end

			table.insert(data, line)
		end
		file:close()
	end

	file = io.open(home .. "/.local/share/nvim/folders.txt", "w")

	if file then
		table.insert(data, path)

		-- Write to the file
		local str = ""
		for _, line in ipairs(data) do
			-- check if path exists
			if helpers.folder_exists(line) then
				str = str .. line .. "\n"
			end
		end
		file:write(str)

		file:close()
	end
end

local M = {
	{
		"nvim-telescope/telescope.nvim",
		event = "VeryLazy", -- "VimEnter",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-tree/nvim-web-devicons" },
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope-file-browser.nvim" },
		},
		config = function()
			require("telescope").setup({
				defaults = {
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--glob=!**/.git/*",
					},
					prompt_prefix = "   ",
					selection_caret = " ",
					entry_prefix = " ",
					sorting_strategy = "ascending",
					layout_config = {
						horizontal = {
							prompt_position = "top",
							preview_width = 0.55,
						},
						width = 0.87,
						height = 0.80,
					},
					mappings = {
						i = {
							["<C-j>"] = "move_selection_next",
							["<C-k>"] = "move_selection_previous",
						},
					},
					file_ignore_patterns = {
						".git/",
						".cache",
						"%.o",
						"%.a",
						"%.out",
						"%.class",
						"%.pdf",
						"%.mkv",
						"%.mp4",
						"%.zip",
					},
				},
				pickers = {
					find_files = {
						hidden = true,
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
					file_browser = {
						hijack_netrw = true,
						hidden = true,
						mappings = {
							["i"] = {
								-- Press Ctrl-c to change to selected directory
								["<C-c>"] = function(prompt_bufnr)
									local fb = require("telescope").extensions.file_browser
									local action_state = require("telescope.actions.state")
									local actions = require("telescope.actions")
									local entry = action_state.get_selected_entry()
									local path = entry.path or entry.value

									actions.close(prompt_bufnr)
									vim.cmd("cd " .. path)
									print("Changed directory to: " .. path)
									SaveFolder(path)
								end,
							},
							["n"] = {
								["<C-c>"] = function(prompt_bufnr)
									local action_state = require("telescope.actions.state")
									local actions = require("telescope.actions")
									local entry = action_state.get_selected_entry()
									local path = entry.path or entry.value

									actions.close(prompt_bufnr)
									vim.cmd("cd " .. path)
									print("Changed directory to: " .. path)
									SaveFolder(path)
								end,
							},
						},
					},
				},
			})

			require("telescope").load_extension("file_browser")

			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
			vim.keymap.set("n", "<leader>fw", builtin.live_grep, { desc = "[F]ind [W]ord" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "[F]ind [B]uffers" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" })
			vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "[F]ind [O]ld files" })
			vim.keymap.set("n", "<leader>fc", builtin.grep_string, { desc = "[F]ind [C]urrent word" })
			vim.keymap.set("n", "<leader>fb", ":Telescope file_browser<CR>")
		end,
	},
}

return M
