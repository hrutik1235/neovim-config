return {
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		config = function()
			require("mason").setup({ ui = { border = "rounded" } })

			local registry = require("mason-registry")
			local tools = { "gofumpt", "goimports", "prettier", "stylua" }

			registry.refresh(function()
				for _, tool in ipairs(tools) do
					local ok, pkg = pcall(registry.get_package, tool)
					if ok and not pkg:is_installed() then
						pkg:install()
					end
				end
			end)
		end,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"gopls",
					"ts_ls",
					"eslint",
					"html",
					"cssls",
					"tailwindcss",
					"jsonls",
					"lua_ls",
				},
				automatic_installation = true,
			})
		end,
	},

	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local on_attach = function(_, bufnr)
				local map = function(keys, func, desc)
					vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
				end
				local tb = require("telescope.builtin")

				map("gd", tb.lsp_definitions, "Go to definition")
				map("gr", tb.lsp_references, "Go to references")
				map("gi", tb.lsp_implementations, "Go to implementation")
				map("gt", tb.lsp_type_definitions, "Go to type definition")
				map("K", vim.lsp.buf.hover, "Hover docs")
				map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
				map("<leader>ca", vim.lsp.buf.code_action, "Code action")
				map("<leader>ds", tb.lsp_document_symbols, "Document symbols")
				map("<leader>f", function()
					vim.lsp.buf.format({ async = true })
				end, "Format buffer")
			end

			-- ── vim.lsp.config (nvim 0.11 native API) ───────────────────────────

			-- Go
			vim.lsp.config("gopls", {
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					gopls = {
						analyses = { unusedparams = true, shadow = true },
						staticcheck = true,
						gofumpt = true,
						usePlaceholders = true,

						-- Add this block
						semanticTokens = true, -- rich semantic highlighting

						hints = {
							parameterNames = true,
							assignVariableTypes = true,
							compositeLiteralFields = true,
							constantValues = true,
							functionTypeParameters = true,
							rangeVariableTypes = true,
						},
					},
				},
			})
			vim.lsp.enable("gopls")

			-- Rust (rust-analyzer comes from rustup: `rustup component add rust-analyzer`)
			vim.lsp.config("rust_analyzer", {
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					["rust-analyzer"] = {
						cargo = { allFeatures = true },
						check = { command = "clippy" },
						procMacro = { enable = true },
					},
				},
			})
			vim.lsp.enable("rust_analyzer")

			-- TypeScript / React
			vim.lsp.config("ts_ls", {
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					typescript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayReturnTypeHints = true,
							includeInlayVariableTypeHints = true,
							includeInlayPropertyDeclarationTypeHints = true,
						},
					},
					javascript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
						},
					},
				},
			})
			vim.lsp.enable("ts_ls")

			-- ESLint (auto-fix on save)
			vim.lsp.config("eslint", {
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					on_attach(client, bufnr)
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						group = vim.api.nvim_create_augroup("EslintFixOnSave-" .. bufnr, { clear = true }),
						callback = function()
							local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "eslint" })
							if #clients > 0 then
								pcall(vim.cmd, "EslintFixAll")
							end
						end,
					})
				end,
			})
			vim.lsp.enable("eslint")

			-- Simple servers (no extra settings needed)
			for _, server in ipairs({ "html", "cssls", "jsonls", "tailwindcss" }) do
				vim.lsp.config(server, { capabilities = capabilities, on_attach = on_attach })
				vim.lsp.enable(server)
			end

			-- Lua (for editing nvim config)
			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
					},
				},
			})
			vim.lsp.enable("lua_ls")

			-- ── Diagnostics UI ──────────────────────────────────────────────────
			vim.diagnostic.config({
				virtual_text = { prefix = "●" },
				signs = true,
				underline = true,
				update_in_insert = false,
				float = { border = "rounded", source = "always" },
			})

			local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end
		end,
	},

	-- Formatters (format on save)
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					go = { "gofumpt", "goimports" },
					rust = { "rustfmt" },
					javascript = { "prettier" },
					javascriptreact = { "prettier" },
					typescript = { "prettier" },
					typescriptreact = { "prettier" },
					css = { "prettier" },
					html = { "prettier" },
					json = { "prettier" },
					yaml = { "prettier" },
					lua = { "stylua" },
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_fallback = true,
				},
			})
		end,
	},
}
