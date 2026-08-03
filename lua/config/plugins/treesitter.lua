return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		config = function()
			require("nvim-treesitter").setup({
				ensure_installed = {
					"go",
					"gomod",
					"gosum",
					"typescript",
					"tsx",
					"javascript",
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
				},
				auto_install = true,
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		lazy = true,
	},
}
