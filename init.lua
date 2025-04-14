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
