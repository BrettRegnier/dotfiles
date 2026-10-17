return {
    {
        "akinsho/toggleterm.nvim",
        opts = {
            direction = "float",
            float_opts = {
                border = "rounded",
            },
        },
        keys = {
            {
                "<leader>q",
                "<cmd>ToggleTerm direction=float<cr>",
                desc = "Toggle Floating Terminal",
            },
        },
    },
}
