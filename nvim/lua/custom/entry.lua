vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		local ft = vim.bo.filetype
		local bt = vim.bo.buftype

		-- ignore dashboards, sidebars, terminals, etc.
		if ft == "alpha" or ft == "NvimTree" or bt ~= "" then
			return
		end

		vim.defer_fn(function()
			if vim.fn.exists(":Minimap") == 2 then
				vim.cmd("Minimap")
			end
		end, 100)
	end,
})
