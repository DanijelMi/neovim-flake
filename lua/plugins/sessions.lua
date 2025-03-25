-- Candidates?
-- https://github.com/ahmedkhalf/project.nvim
-- https://github.com/coffebar/neovim-project
-- https://github.com/jedrzejboczar/possession.nvim
-- https://github.com/olimorris/persisted.nvim
-- https://github.com/rmagatti/auto-session
-- https://github.com/stevearc/resession.nvim
-- https://github.com/superDross/ticket.vim
-- https://github.com/tpope/vim-obsession
-- https://github.com/Shatur/neovim-session-manager
-- https://github.com/gennaro-tedesco/nvim-possession
return {
	{
		"gennaro-tedesco/nvim-possession",
		dependencies = {
			"ibhagwan/fzf-lua",
		},
		config = function()
			require("nvim-possession").setup({
				autoload = true,
				autoswitch = {
					enable = true, -- Close buffers not related to the newly switched session
				},
			})
		end,
		keys = {
			{
				"<leader>sl",
				function()
					require("nvim-possession").list()
				end,
				desc = "📌list sessions",
			},
			{
				"<leader>sn",
				function()
					require("nvim-possession").new()
				end,
				desc = "📌create new session",
			},
			{
				"<leader>su",
				function()
					require("nvim-possession").update()
				end,
				desc = "📌update current session",
			},
			{
				"<leader>sd",
				function()
					require("nvim-possession").delete()
				end,
				desc = "📌delete selected session",
			},
		},
	},
}
