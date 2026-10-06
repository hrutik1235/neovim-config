return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		config = function()
			-- main branch: ensure_installed/auto_install are gone, parsers are installed explicitly
			require("nvim-treesitter").install({
				"go",
				"gomod",
				"gosum",
				"gowork",
				"rust",
				"typescript",
				"tsx",
				"javascript",
				"jsdoc",
				"html",
				"css",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"bash",
				"yaml",
				"toml",
				"regex",
			})

			-- main branch: highlighting is not enabled by default, start it per buffer
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("TreesitterHighlight", { clear = true }),
				callback = function(args)
					pcall(vim.treesitter.start, args.buf)
				end,
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		lazy = true,
	},
}
