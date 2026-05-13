-- ~/.config/nvim/lua/my_project_picker.lua
local M = {}

function M.open()
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	local handle = io.popen('find ~/code -maxdepth 4 -type d -name ".git" 2>/dev/null')
	local results = {}
	for path in handle:lines() do
		table.insert(results, vim.fn.fnamemodify(path, ":h"))
	end
	handle:close()

	pickers
		.new({}, {
			prompt_title = "Select Project Directory",
			finder = finders.new_table({ results = results }),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, _)
				actions.select_default:replace(function()
					local selection = action_state.get_selected_entry()
					actions.close(prompt_bufnr)
					vim.cmd("cd " .. selection[1])
					print("Changed to: " .. selection[1])
				end)
				return true
			end,
		})
		:find()
end

return M
