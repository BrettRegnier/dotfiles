return {
    "mg979/vim-visual-multi", branch="master",
    init = function()
    vim.g.VM_maps = {
      ["Find Under"]         = "<C-d>",
      ["Find Subword Under"] = "<C-d>",
      ["Select All"]         = "<C-a>",
      ["Skip Region"]        = "<C-x>",
      ["Remove Region"]      = "<C-p>",
    }
    end,
}
