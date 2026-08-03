return {
	"supermaven-inc/supermaven-nvim",
	event = "InsertEnter",
	config = function()
		require("supermaven-nvim").setup({
			-- Accept/next-item handled manually in completion.lua's <Tab> mapping
			-- so it doesn't fight with nvim-cmp's own <Tab> binding.
			disable_keymaps = true,
		})

		vim.keymap.set("i", "<C-]>", function()
			require("supermaven-nvim.completion_preview").on_dispose_inlay()
		end, { desc = "Supermaven: clear suggestion" })
	end,
}
