return {
	-- VSCode-style peek window (Peek Definition / Peek References)
	{
		"dnlhc/glance.nvim",
		cmd = "Glance",
		keys = {
			{ "gp", "<cmd>Glance definitions<CR>", desc = "Peek definition" },
			{ "gP", "<cmd>Glance references<CR>", desc = "Peek references" },
			{ "gY", "<cmd>Glance type_definitions<CR>", desc = "Peek type definition" },
			{ "gI", "<cmd>Glance implementations<CR>", desc = "Peek implementations" },
		},
		config = function()
			require("glance").setup({
				border = { enable = true },
				-- jump straight there when there is only one result for references etc.
				hooks = {
					before_open = function(results, open, jump, method)
						if #results == 1 and method ~= "definitions" then
							jump(results[1])
						else
							open(results)
						end
					end,
				},
			})
		end,
	},
}
