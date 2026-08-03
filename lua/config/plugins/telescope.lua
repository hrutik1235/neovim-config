return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
      local telescope = require("telescope")
      local actions   = require("telescope.actions")

      telescope.setup({
        defaults = {
          file_ignore_patterns = {
            "node_modules", ".git/", "dist/", "build/",
            "vendor/", "%.lock", "__pycache__",
          },
          layout_config = { horizontal = { preview_width = 0.55 } },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<Esc>"] = actions.close,
            },
          },
        },
        extensions = {
          ["ui-select"] = { require("telescope.themes").get_dropdown() },
        },
      })

      telescope.load_extension("fzf")
      telescope.load_extension("ui-select")

      local tb  = require("telescope.builtin")
      local map = vim.keymap.set

      map("n", "<leader>ff", tb.find_files,                { desc = "Find files" })
      map("n", "<leader>fg", tb.live_grep,                 { desc = "Live grep" })
      map("n", "<leader>fb", tb.buffers,                   { desc = "Buffers" })
      map("n", "<leader>fh", tb.help_tags,                 { desc = "Help tags" })
      map("n", "<leader>fr", tb.oldfiles,                  { desc = "Recent files" })
      map("n", "<leader>fc", tb.commands,                  { desc = "Commands" })
      map("n", "<leader>fd", tb.diagnostics,               { desc = "Diagnostics" })
      map("n", "<leader>fs", tb.lsp_document_symbols,      { desc = "Document symbols" })
      map("n", "<leader>fS", tb.lsp_workspace_symbols,     { desc = "Workspace symbols" })
      map("n", "<leader>gc", tb.git_commits,               { desc = "Git commits" })
      map("n", "<leader>gs", tb.git_status,                { desc = "Git status" })
    end,
  },
}
