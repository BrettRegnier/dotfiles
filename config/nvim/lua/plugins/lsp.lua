-- ~/.config/nvim/lua/plugins/lsp.lua

local M = {
	"neovim/nvim-lspconfig",
	event = "VeryLazy",
	dependencies = {
		{ "williamboman/mason.nvim", config = true },
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{ "simrat39/rust-tools.nvim" },
		{ "j-hui/fidget.nvim", opts = {} },
		"hrsh7th/cmp-nvim-lsp",
	},

	config = function()
		----------------------------------------------------------------------
		-- LSP ATTACH
		----------------------------------------------------------------------
		require("lazydev").setup({})

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc)
					vim.keymap.set("n", keys, func, {
						buffer = event.buf,
						desc = "LSP: " .. desc,
					})
				end

				local tb = require("telescope.builtin")
				map("gd", tb.lsp_definitions, "[G]oto [D]efinition")
				map("gr", tb.lsp_references, "[G]oto [R]eferences")
				map("gI", tb.lsp_implementations, "[G]oto [I]mplementation")
				map("<leader>D", tb.lsp_type_definitions, "Type [D]efinition")
				map("<leader>ds", tb.lsp_document_symbols, "[D]ocument [S]ymbols")
				map("<leader>ws", tb.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
				map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
				map("K", function()
					vim.lsp.buf.hover({ border = "rounded" })
				end, "Hover Documentation")
				map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client.server_capabilities.documentHighlightProvider then
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						callback = vim.lsp.buf.document_highlight,
					})
					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						callback = vim.lsp.buf.clear_references,
					})
				end
			end,
		})

		----------------------------------------------------------------------
		-- CAPABILITIES
		----------------------------------------------------------------------
		local capabilities = vim.tbl_deep_extend(
			"force",
			vim.lsp.protocol.make_client_capabilities(),
			require("cmp_nvim_lsp").default_capabilities()
		)

		----------------------------------------------------------------------
		-- SERVER CONFIG
		----------------------------------------------------------------------
		local servers = {
			lua_ls = {
				settings = {
					Lua = {
						completion = { callSnippet = "Replace" },
						diagnostics = {
							globals = { "vim" },
							disable = { "missing-fields" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
					},
				},
			},

			clangd = {
				cmd = {
					vim.fn.stdpath("data") .. "/mason/bin/clangd",
					"--background-index",
					"--clang-tidy",
					"--completion-style=detailed",
					"--header-insertion=iwyu",
					"--function-arg-placeholders",
					-- REQUIRED for STM32 + multi-toolchain
					"--query-driver=/usr/bin/*-gcc,/usr/bin/*-g++,/opt/*/bin/*-gcc,/opt/*/bin/*-g++,"
						.. vim.fn.expand("~")
						.. "/.espressif/tools/xtensa-esp-elf/*/bin/xtensa-esp32-elf-gcc,"
						.. vim.fn.expand("~")
						.. "/.espressif/tools/xtensa-esp-elf/*/bin/xtensa-esp32-elf-g++",
				},
				root_dir = require("lspconfig.util").root_pattern("compile_commands.json", ".clangd", ".git"),
			},
		}

		----------------------------------------------------------------------
		-- MASON
		----------------------------------------------------------------------
		require("mason").setup()

		require("mason-tool-installer").setup({
			ensure_installed = {
				"lua-language-server",
				"clangd",
				"rust-analyzer",
				"stylua",
				"clang-format",
			},
			run_on_start = true,
		})

		----------------------------------------------------------------------
		-- MASON-LSPCONFIG (CORRECT API)
		----------------------------------------------------------------------
		require("mason-lspconfig").setup({
			handlers = {
				-- Default handler
				function(server_name)
					local server = servers[server_name] or {}
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})

					require("lspconfig")[server_name].setup(server)
				end,

				-- Rust handled separately
				["rust_analyzer"] = function()
					require("rust-tools").setup({
						server = {
							capabilities = capabilities,
						},
					})
				end,
			},
		})
	end,
}

----------------------------------------------------------------------
-- DIAGNOSTICS
----------------------------------------------------------------------
vim.diagnostic.config({
	virtual_text = {
		source = "if_many",
		prefix = "●",
		spacing = 2,
	},
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

----------------------------------------------------------------------
-- DIAGNOSTIC SIGNS
----------------------------------------------------------------------
local signs = {
	Error = " ",
	Warn = " ",
	Hint = "󰠠 ",
	Info = " ",
}

for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

return M
