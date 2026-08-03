return {
	{
		"sphamba/smear-cursor.nvim",
		opts = {
			stiffness = 0.8, -- how smooth the movement is
			trailing_stiffness = 0.5,
			trailing_exponent = 5,
			distance_stop_animating = 0.5,
		},
	},
	{
		"kdheepak/lazygit.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			vim.keymap.set("n", "<leader>lg", "<cmd>LazyGit<CR>", { desc = "Open LazyGit" })
		end,
	},
	-- Colorscheme
	{
		"rebelot/kanagawa.nvim",
		priority = 1000,
		config = function()
			require("kanagawa").setup({
				compile = false, -- enable compiling the colorscheme
				undercurl = true, -- enable undercurls
				commentStyle = { italic = true },
				functionStyle = {},
				keywordStyle = { italic = true },
				statementStyle = { bold = true },
				typeStyle = {},
				transparent = true, -- do not set background color
				dimInactive = false, -- dim inactive window `:h hl-NormalNC`
				terminalColors = true, -- define vim.g.terminal_color_{0,17}
				colors = { -- add/modify theme and palette colors
					palette = {},
					theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
				},
				overrides = function(colors) -- add/modify highlights
					return {}
				end,
				theme = "wave", -- Load "wave" theme
				background = { -- map the value of 'background' option to a theme
					dark = "wave", -- try "dragon" !
					light = "lotus",
				},
			})
			vim.cmd.colorscheme("kanagawa-wave")
		end,
	},

	-- Status line
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "kanagawa",
					component_separators = "|",
					section_separators = "",
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { { "filename", path = 1 } },
					lualine_x = { "encoding", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
			})
		end,
	},

	-- File tree
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("nvim-tree").setup({
				filters = { dotfiles = false },
				view = { width = 35 },
				renderer = {
					highlight_git = true,
					icons = { show = { git = true } },
				},
			})
			vim.keymap.set("n", "<leader>t", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file tree" })
			vim.keymap.set("n", "<leader>tf", "<cmd>NvimTreeFindFile<CR>", { desc = "Find file in tree" })
		end,
	},

	-- Which-key: shows available keybindings
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			require("which-key").setup({ delay = 500 })
		end,
	},

	-- Indent guides
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		config = function()
			vim.api.nvim_set_hl(0, "IblScope", { fg = "#3b4048" })

			require("ibl").setup({
				indent = { char = " " },
				scope = { enabled = true, char = "│", show_start = false, show_end = false, highlight = "IblScope" },
			})
		end,
	},

	-- Auto pairs
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({})
			-- integrate with cmp
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},

	-- Auto close/rename HTML/JSX tags
	{
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},

	-- Git signs in gutter
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "+" },
					change = { text = "~" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
				},
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns
					local map = function(mode, l, r, desc)
						vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
					end
					map("n", "]c", gs.next_hunk, "Next git hunk")
					map("n", "[c", gs.prev_hunk, "Prev git hunk")
					map("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
					map("n", "<leader>gu", gs.undo_stage_hunk, "Undo stage hunk")
					map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
					map("n", "<leader>gb", gs.blame_line, "Git blame line")
				end,
			})
		end,
	},
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("bufferline").setup({
				options = {
					mode = "buffers",
					separator_style = "slant", -- "slant" | "thick" | "thin" | "padded_slant"
					always_show_bufferline = true,
					show_buffer_close_icons = true,
					show_close_icon = false,
					color_icons = true,
					diagnostics = "nvim_lsp", -- shows error/warn count on tab
					diagnostics_indicator = function(count, level)
						local icon = level:match("error") and " " or " "
						return icon .. count
					end,
					offsets = {
						{
							filetype = "NvimTree",
							text = "Files",
							highlight = "Directory",
							separator = true,
						},
					},
				},
			})

			local map = vim.keymap.set
			map("n", "[b", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
			map("n", "]b", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
			map("n", "<leader>bp", "<cmd>BufferLineTogglePin<CR>", { desc = "Pin buffer" })
			map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Close buffer" })
		end,
	},

	-- Comment toggling
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},

	-- Better notifications
	{
		"rcarriga/nvim-notify",
		config = function()
			vim.notify = require("notify")
		end,
	},
}
