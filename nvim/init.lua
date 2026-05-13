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

