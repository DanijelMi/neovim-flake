return {
	{ "folke/tokyonight.nvim" }, -- Colorscheme
	{
		"rebelot/kanagawa.nvim",
		config = function()
			require("kanagawa").setup({
				compile = true,
				-- Requires :KanagawaCompile
				dimInactive = true,
				terminalColors = true,
			})
			vim.cmd.colorscheme("kanagawa")
		end,
		build = function()
			vim.cmd("KanagawaCompile")
		end,
	}, -- Colorscheme
	{ "EdenEast/nightfox.nvim" }, -- Colorscheme
	{ "navarasu/onedark.nvim" }, -- Colorscheme
	{ "sainnhe/everforest" }, -- Colorscheme
	{ "rose-pine/neovim", name = "rose-pine" }, -- Colorscheme
	{
		"catppuccin/nvim", -- Colorscheme
		name = "catppuccin",
		config = function()
			require("catppuccin").setup({ transparent_background = true })
		end,
	},
	{
		"folke/styler.nvim", -- Colorscheme per filetype
		config = function()
			require("styler").setup({
				themes = {
					markdown = { colorscheme = "torte" },
					help = { colorscheme = "tokyonight", background = "dark" },
					terraform = { colorscheme = "catppuccin-mocha", background = "dark" }, -- TODO: find a purple colorscheme here
					terminal = { colorscheme = "tokyonight-night", background = "dark", transparent_background = false },
				},
				-- Usually terminal buffers have no filetype set, so we set it up for Styler to work
				vim.api.nvim_create_autocmd({ "TermOpen" }, {
					pattern = "*",
					callback = function()
						vim.bo.filetype = "terminal"
					end,
				}),
			})
		end,
	},
	{
		"sphamba/smear-cursor.nvim",
		opts = {
			smear_to_cmd = false, -- nvim 0.11 regression https://github.com/neovim/neovim/issues/32068
			stiffness = 0.8,
			trailing_stiffness = 0.4,
			distance_stop_animating = 0.1, -- 0.1      > 0
		},
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			win = {
				no_overlap = false, -- don't allow the popup to overlap with the cursor
				padding = { 0, 0 }, -- extra window padding [top/bottom, right/left]
			},
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
	-- {
	-- 	"lukas-reineke/indent-blankline.nvim",
	-- 	main = "ibl",
	-- 	---@module "ibl"
	-- 	---@type ibl.config
	-- 	-- opts = {},
	-- 	opts = {},
	-- 	-- config = function()
	-- 	-- 	require("ibl").setup()
	-- 	-- 	-- vim.opt.listchars = { space = "·", tab = "→ " }
	-- 	-- end,
	-- },
}
