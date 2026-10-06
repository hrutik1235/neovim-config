vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set

-- ─── Motion ───────────────────────────────────────────────────────────────────
-- ww → end of line (normal + visual)
map("n", "ww", "$", { desc = "Go to end of line" })
map("v", "ww", "$", { desc = "Go to end of line" })

-- delete without copying (normal + visual)
map("n", "<leader>d", [["_d]], { desc = "Delete without yank" })
map("v", "<leader>d", [["_d]], { desc = "Delete without yank" })

-- ─── Splits ───────────────────────────────────────────────────────────────────
map("n", "|", "<cmd>vsplit<CR>", { desc = "Split right" })
map("n", "\\", "<cmd>split<CR>", { desc = "Split down" })

-- ─── Window navigation ────────────────────────────────────────────────────────
map("n", "<C-h>", "<C-w>h", { desc = "Focus left split" })
map("n", "<C-l>", "<C-w>l", { desc = "Focus right split" })
map("n", "<C-j>", "<C-w>j", { desc = "Focus lower split" })
map("n", "<C-k>", "<C-w>k", { desc = "Focus upper split" })

-- Close active split/window (VSCode: closeActiveEditor)
map("n", "<C-w>q", "<cmd>close<CR>", { desc = "Close active split" })

-- Ctrl+S to save (normal, insert, and visual mode)
map("n", "<C-s>", "<cmd>w<CR>", { desc = "Save" })
map("i", "<C-s>", "<Esc><cmd>w<CR>a", { desc = "Save (insert mode)" })
map("v", "<C-s>", "<Esc><cmd>w<CR>", { desc = "Save (visual mode)" })

-- Resize splits
map("n", "<C-Up>", "<cmd>resize +2<CR>")
map("n", "<C-Down>", "<cmd>resize -2<CR>")
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>")
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>")

-- ─── Buffer navigation ────────────────────────────────────────────────────────
-- [b / ]b → prev/next buffer (VSCode: previousEditor / nextEditor)
map("n", "[b", "<cmd>bprevious<CR>", { desc = "Prev buffer" })
map("n", "]b", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

-- ─── UI Toggles ───────────────────────────────────────────────────────────────
-- <leader>e  → toggle file tree (VSCode: toggleSidebarVisibility)
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file tree" })

-- <leader>ac → toggle statusline (closest to activitybar toggle)
map("n", "<leader>ac", function()
	if vim.o.laststatus == 0 then
		vim.o.laststatus = 2
	else
		vim.o.laststatus = 0
	end
end, { desc = "Toggle statusline" })

-- <leader>sm → toggle minimap (if minimap plugin present, else no-op stub)
map("n", "<leader>sm", function()
	local ok, _ = pcall(vim.cmd, "MinimapToggle")
	if not ok then
		vim.notify("No minimap plugin installed", vim.log.levels.INFO)
	end
end, { desc = "Toggle minimap" })

-- ─── Terminal ─────────────────────────────────────────────────────────────────
-- <leader>th → toggle floating terminal (VSCode: toggleTerminal)
map("n", "<leader>th", function()
	-- Works with toggleterm.nvim if installed, falls back to built-in terminal
	local ok, toggleterm = pcall(require, "toggleterm")
	if ok then
		vim.cmd("ToggleTerm")
	else
		-- built-in: open terminal in horizontal split
		vim.cmd("botright split | terminal")
	end
end, { desc = "Toggle terminal" })

-- Easy escape from built-in terminal
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- ─── Fuzzy find ───────────────────────────────────────────────────────────────
-- <leader>ff → Telescope find files (VSCode: quickOpen)
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Buffers" })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { desc = "Recent files" })
map("n", "<leader>fd", "<cmd>Telescope diagnostics<CR>", { desc = "Diagnostics" })
map("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "Document symbols" })
map("n", "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<CR>", { desc = "Workspace symbols" })
map("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "Git commits" })
map("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "Git status" })

-- ─── Insert mode ──────────────────────────────────────────────────────────────
-- jk → Escape (muscle memory from VSCode vim extension)
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- ─── Line manipulation ────────────────────────────────────────────────────────
-- Move lines in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep cursor centered when scrolling
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Paste without losing register
map("x", "<leader>p", [["_dP]], { desc = "Paste without losing register" })

-- ─── Save / Quit ──────────────────────────────────────────────────────────────
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })

-- ─── Diagnostics ──────────────────────────────────────────────────────────────
map("n", "<leader>de", vim.diagnostic.open_float, { desc = "Open diagnostic float" })
map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Prev diagnostic" })
map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next diagnostic" })
-- errors only (skip warnings/hints)
map("n", "[e", function() vim.diagnostic.jump({ count = -1, float = true, severity = vim.diagnostic.severity.ERROR }) end, { desc = "Prev error" })
map("n", "]e", function() vim.diagnostic.jump({ count = 1, float = true, severity = vim.diagnostic.severity.ERROR }) end, { desc = "Next error" })
-- all problems in the current file (VSCode: Problems panel, current file)
map("n", "<leader>fx", function() require("telescope.builtin").diagnostics({ bufnr = 0 }) end, { desc = "Diagnostics (current file)" })

-- ─── Go shortcuts ─────────────────────────────────────────────────────────────
map("n", "<leader>gr", "<cmd>!go run .<CR>", { desc = "Go: run" })
map("n", "<leader>gt", "<cmd>!go test ./...<CR>", { desc = "Go: test all" })
map("n", "<leader>gb", "<cmd>!go build ./...<CR>", { desc = "Go: build" })

-- ─── Misc ─────────────────────────────────────────────────────────────────────
-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>")
