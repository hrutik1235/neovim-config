require("config.options")
require("config.keymaps")
require("config.lazy")

-- Neovide settings
if vim.g.neovide then
	-- Font
	vim.o.guifont = "JetBrainsMono Nerd Font:h14"

	-- Disable cursor animations completely
	vim.g.neovide_cursor_animation_length = 0
	vim.g.neovide_cursor_trail_size = 0
	vim.g.neovide_cursor_vfx_mode = ""

	-- Disable cursor blinking animations
	vim.g.neovide_cursor_smooth_blink = false
	vim.g.neovide_cursor_animate_command_line = false

	-- Smooth scrolling
	vim.g.neovide_scroll_animation_length = 0.2

	-- Window opacity
	vim.g.neovide_opacity = 0.95

	-- Refresh rate
	vim.g.neovide_refresh_rate = 144

	-- Optional performance tweaks
	vim.g.neovide_hide_mouse_when_typing = true
	vim.g.neovide_confirm_quit = true
end
