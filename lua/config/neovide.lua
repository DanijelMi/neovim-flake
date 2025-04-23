if vim.g.neovide then
	vim.keymap.set({ "n", "v" }, "<C-=>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>")
	vim.keymap.set({ "n", "v" }, "<C-->", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>")
	vim.keymap.set({ "n", "v" }, "<C-0>", ":lua vim.g.neovide_scale_factor = 1<CR>")
	vim.keymap.set(
		{ "n", "v" },
		"<C-ScrollWheelUp>",
		":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>"
	)
	vim.keymap.set(
		{ "n", "v" },
		"<C-ScrollWheelDown>",
		":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>"
	)
	-- Do :set guifont=* to see and test all fonts
	vim.o.guifont = "MesloLGS Nerd Font Propo:h11"
	vim.opt.linespace = -2
	vim.g.neovide_normal_opacity = 0.93
	vim.g.neovide_position_animation_length = 0.2
	vim.g.neovide_scroll_animation_length = 0.1
	vim.g.neovide_cursor_animation_length = 0.04

	vim.g.neovide_cursor_vfx_mode = "wireframe"
	vim.g.neovide_cursor_vfx_opacity = 80.0
end
