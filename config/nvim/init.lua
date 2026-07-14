vim.g.mapleader = " "
vim.g.maplocalleader = " "

local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazy_path) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazy_path,
	})
end
vim.opt.rtp:prepend(lazy_path)

-- Load plugins
require("lazy").setup("plugins", {
	change_detection = {
		notify = false,
	},
})

-- Load in my changes
require("configs/options")
require("configs/mappings")
require("custom/entry")

require("custom/theme-selector")

-- TODO move into "server.lua component?"
local socket_dir = vim.fn.expand("~/.cache/nvim/sockets/")
vim.fn.mkdir(socket_dir, "p")

-- Get Neovim's actual active socket path
local real_socket = vim.v.servername
local my_shortcut = socket_dir .. "nvim_" .. vim.loop.os_getpid() .. ".pipe"

-- Create a symlink to the real socket so our script can find it
if real_socket and real_socket ~= "" then
	os.execute(string.format("ln -sf %s %s", real_socket, my_shortcut))
end

-- Clean up the shortcut link when this Neovim instance exits
vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
		os.remove(my_shortcut)
	end,
})
