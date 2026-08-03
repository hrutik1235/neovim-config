return {
	"CopilotC-Nvim/CopilotChat.nvim",
	dependencies = {
		"zbirenbaum/copilot.lua",
		"nvim-lua/plenary.nvim",
	},
	build = "make tiktoken",
	config = function()
		require("CopilotChat").setup({
			window = {
				layout = "vertical", -- "vertical" | "horizontal" | "float"
				width = 0.4, -- 40% of screen
			},
		})

		local map = vim.keymap.set
		local chat = require("CopilotChat")

		-- Open/close chat
		map("n", "<leader>cc", "<cmd>CopilotChatToggle<CR>", { desc = "Copilot: toggle chat" })

		-- Ask about selected code (visual mode)
		map("v", "<leader>ce", "<cmd>CopilotChatExplain<CR>", { desc = "Copilot: explain" })
		map("v", "<leader>cf", "<cmd>CopilotChatFix<CR>", { desc = "Copilot: fix" })
		map("v", "<leader>cr", "<cmd>CopilotChatReview<CR>", { desc = "Copilot: review" })
		map("v", "<leader>ct", "<cmd>CopilotChatTests<CR>", { desc = "Copilot: generate tests" })
		map("v", "<leader>co", "<cmd>CopilotChatOptimize<CR>", { desc = "Copilot: optimize" })

		-- Quick prompt
		map("n", "<leader>cp", function()
			local input = vim.fn.input("Copilot: ")
			if input ~= "" then
				chat.ask(input)
			end
		end, { desc = "Copilot: quick prompt" })
	end,
}
