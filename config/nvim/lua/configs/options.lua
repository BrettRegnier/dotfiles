-- ~/.config/nvim/settings/settings.lua

local helpers = require("../custom/helpers")

local opt = vim.opt
local g = vim.g
local api = vim.api

opt.number = true
opt.relativenumber = false
opt.mouse = "a" -- turn on mouse
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.wrap = false
opt.breakindent = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.updatetime = 250 -- time in ms before swap file is written or cursorhold triggers
opt.timeoutlen = 300 -- time in ms to wait for a mapped key seq to complete
opt.splitright = true -- vs opens on right
opt.splitbelow = true -- sp opens below current active window
opt.undofile = true
opt.scrolloff = 8 -- keeps at least x lines visible above and below the cursor when scrolling
opt.sidescrolloff = 8 -- keeps at leat x lines visible on side scroll
opt.cursorline = true -- highlights the line under the cursor
opt.clipboard = "unnamedplus" -- uses the system clipboard
opt.fillchars = { eob = " " }
opt.numberwidth = 4
opt.ruler = false

g.neovide_remember_window_size = true
g.neovide_scale_factor = 0.7
g.guifont = "JetBrainsMono Nerd Font:h9"

vim.o.exrc = true
vim.o.secure = true
