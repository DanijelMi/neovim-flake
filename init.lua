require("config.vim-options") -- General neovim options
require("config.terminal") -- All things :terminal
require("config.arglist") -- All things :arglist
require("config.diff") -- All things diff
require("config.lazy") -- Load plugin manager and all plugins

-- Staging zone temporary logic goes here

-- How to troubleshoot highlights:
-- :FzfLua highlights
-- :Inspect!

-- Filetype recognition overrides
vim.filetype.add({
	extension = {
		tf = "terraform",
	},
})

-- Neovide logic
if vim.g.neovide then
	vim.keymap.set({ "n", "v" }, "<C-+>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>")
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
end
