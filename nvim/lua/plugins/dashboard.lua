-- Dashboard
local helpers = require("custom/helpers")

local M = {
	"goolord/alpha-nvim",
	event = "VimEnter",
	dependencies = { "nvim-telescope/telescope.nvim" },
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")
		dashboard.section.header.val = {
			"       ██╗       ",
			"       ██║       ",
			"       ██║       ",
			"       ██║       ",
			"████████████████╗",
			"╚══════██╔══════╝",
			"       ██║       ",
			"       ██║       ",
			"       ██║       ",
			"       ██║       ",
			"       ██║       ",
			"       ██║       ",
			"       ██║       ",
			"       ╚═╝       ",
			" Christ is Lord  ",
		}

		-- Increase width by adjusting padding
		dashboard.opts.layout = {
			{ type = "padding", val = 2 },
			dashboard.section.header,
			{ type = "padding", val = 2 },
			dashboard.section.buttons,
			dashboard.section.footer,
		}

		-- Set a custom width for buttons
		dashboard.section.buttons.opts = {
			spacing = 1,
		}

		dashboard.section.buttons.val = {
			-- TODO change to the _fb
			-- dashboard.button("p", "   Open project", ":lua require('../custom/project_picker').open()<CR>"),
			dashboard.button(
				"p",
				"    Open folder",
				"<cmd>lua require('telescope').extensions.file_browser.file_browser({ cwd = vim.fn.expand('~') })<CR>"
			),
			dashboard.button("c", "    Config", ":cd ~/.config/nvim<CR>:e init.lua<CR>"),
		}

		local home = os.getenv("HOME") or os.getenv("USERPROFILE")

		local file = io.open(home .. "/.local/share/nvim/folders.txt", "r")

		local idx = 1
		if file then
			while true do
				local line = file:read("*l")
				if not line then
					break
				end

				if idx >= 10 then
					break
				end

				-- test if line exists, if it doesn't remove it.
				if helpers.folder_exists(line) then
					table.insert(
						dashboard.section.buttons.val,
						dashboard.button(
							tostring(idx),
							"    [" .. tostring(idx) .. "] " .. line:match("([^/]+)/?$") .. " -> " .. line,
							":cd " .. line .. "<CR>"
						)
					)
					idx = idx + 1
				end
			end
		end

		for _, button in ipairs(dashboard.section.buttons.val) do
			button.opts.width = 130
		end

		local function centerText(text, width)
			local totalPadding = width - #text
			local leftPadding = math.floor(totalPadding / 2)
			local rightPadding = totalPadding - leftPadding
			return string.rep(" ", leftPadding) .. text .. string.rep(" ", rightPadding)
		end

		local time = os.date("%H:%M")
		local date = os.date("%a %d %b")
		local v = vim.version()
		local version = " v" .. v.major .. "." .. v.minor .. "." .. v.patch
		dashboard.section.footer.val = {
			"",
			"Do nothing from selfish ambition or conceit, but in humility count others more significant than yourselves",
			centerText("-Philippians 2:3", 100),
			" ",
			centerText(date, 100),
			centerText(time, 100),
			centerText(version, 100),
		}

		alpha.setup(dashboard.opts)
	end,
}

return M
