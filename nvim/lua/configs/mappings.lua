local map = vim.keymap.set
-- Moving the cursor during insert mode
map("i", "<C-h>", "<Left>")
map("i", "<C-j>", "<Down>")
map("i", "<C-k>", "<Up>")
map("i", "<C-l>", "<Right>")
-- Disable space
map("n", "<Space>", "<Nop>", { noremap = true, silent = true })

-- Colour theme mappings
map("n", "<leader>td", "<cmd>colorscheme base16-ashes<CR>", { desc = "Theme: Ashes (dark)" })
map("n", "<leader>tl", "<cmd>colorscheme base16-one-light<CR>", { desc = "Theme: One Light" })

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Telescope
-- map("n", "<C-p>", "<cmd> Telescope find_files <CR>")
-- map("n", "fp", "<cmd> Telescope find_files <CR>")
map("n", "<C-u>", "<cmd> Telescope lsp_document_symbols <CR>")
map("n", "fu", "<cmd> Telescope lsp_document_symbols <CR>")

-- Indenting
map("v", "<S-Tab>", "<gv")
map("i", "<S-Tab>", "<C-d>")
map("v", ",", "<gv")
map("v", ".", ">gv")

-- Moving a line up or down
map("n", "<A-j>", ":m .+1<CR>==") -- move line up(n)
map("n", "<A-k>", ":m .-2<CR>==") -- move line down(n)
map("v", "<A-j>", ":m '>+1<CR>gv=gv") -- move line up(v)
map("v", "<A-k>", ":m '<-2<CR>gv=gv") -- move line down(v)

-- Change focus of windows
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to upper window" })
map("n", "<C-h>", ":TmuxNavigateLeft<CR>")
map("n", "<C-j>", ":TmuxNavigateDown<CR>")
map("n", "<C-k>", ":TmuxNavigateUp<CR>")
map("n", "<C-l>", ":TmuxNavigateRight<CR>")

-- Switch windows
map("n", "fh", "<C-h>")
map("n", "fj", "<C-j>")
map("n", "fk", "<C-k>")
map("n", "fl", "<C-l>")
map("n", "fh", ":TmuxNavigateLeft<CR>")
map("n", "fj", ":TmuxNavigateDown<CR>")
map("n", "fk", ":TmuxNavigateUp<CR>")
map("n", "fl", ":TmuxNavigateRight<CR>")

map("t", "<esc>", "<C-\\><C-n>")
map("t", "jk", "<C-\\><C-n>")
map("t", ":q", "exit<CR>")

-- LSP mappings
-- map("n", "K", vim.lsp.buf.hover, { desc = "LSP Hover" })

-- Delete empty lines with x
map("n", "x", function()
	local line = vim.api.nvim_get_current_line()
	if line:match("^%s*$") then
		-- line is empty delete the whole line
		vim.cmd("normal! dd")
	else
		-- Line has content
		vim.cmd("normal! x")
	end
end, { noremap = true, desc = "Delete char or empty line" })

map("n", "i", function()
	local line = vim.fn.getline(".")
	if line:match("^%s*$") then
		return "cc" -- clear line and insert with correct indent
	else
		return "i"
	end
end, { expr = true, noremap = true })

-- Open dashboard
map("n", "<leader>dd", "<cmd>Alpha<CR>", { desc = "Open dashboard" })

-- Open file picker
local function find_files_multi_dir()
    local extra = vim.g.extra_search_dir
    local cmd = { 'fd', '--type', 'f', '.', '.' }

    if extra and extra ~= '' then
        local paths = vim.split(extra, "%s+")  -- split on whitespace
        for _, p in ipairs(paths) do
            table.insert(cmd, vim.fn.expand(p))
        end
    end

    require('telescope.builtin').find_files({ find_command = cmd })
end

vim.keymap.set("n", "<C-p>", find_files_multi_dir)
vim.keymap.set("n", "fp", find_files_multi_dir)


