-- ~/.config/nvim/lua/config/plugins/toggleterm.lua
return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup({
				size = 15,
				open_mapping = [[<leader>th]],
				direction = "horizontal", -- "float" | "horizontal" | "vertical"
				shade_terminals = true,
				start_in_insert = true,
				persist_mode = true,
				float_opts = {
					border = "rounded",
					width = math.floor(vim.o.columns * 0.85),
					height = math.floor(vim.o.lines * 0.80),
				},
			})

			-- Exit terminal mode with Esc Esc
			vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

			-- Navigate out of terminal into splits with Ctrl+hjkl
			vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h")
			vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l")
			vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j")
			vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k")
		end,
	},
}
