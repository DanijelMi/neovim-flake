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
			require("catppuccin").setup({
				transparent_background = false,
				term_colors = true,
				color_overrides = {
					latte = {},
					-- Customizing for terraform
					frappe = {
						base = "#2c1734",
					},
					macchiato = {
						base = "#1a1837",
					},
					mocha = {},
				},
				styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
					booleans = { "bold" },
					properties = {},
					types = {},
					operators = {},
					-- miscs = {}, -- Uncomment to turn off hard-coded styles
				},
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},
	{
		"folke/styler.nvim", -- Colorscheme per filetype
		config = function()
			require("styler").setup({
				themes = {
					help = { colorscheme = "tokyonight-storm", background = "dark" },
					markdown = { colorscheme = "dayfox", background = "dark" },
					terraform = { colorscheme = "catppuccin-frappe", background = "dark" },
				},
				-- :terminal does not have filetype, just buffertype
				-- We can't use filetype-based settings and have to create a manual exception
				vim.api.nvim_create_autocmd({ "TermEnter" }, {
					pattern = "*",
					callback = function()
						require("styler").set_theme(0, {
							colorscheme = "kanagawa-dragon",
						})
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
	{
		"cuducos/yaml.nvim",
		ft = { "yaml" }, -- optional
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			-- "folke/snacks.nvim", -- optional
			-- "nvim-telescope/telescope.nvim", -- optional
			-- "ibhagwan/fzf-lua", -- optional
		},
		config = function()
			-- Create a bind for yanking the full key path + value
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "yaml",
				callback = function()
					vim.api.nvim_buf_set_keymap(
						0,
						"n",
						"Y",
						[[:lua require('yaml_nvim').yank('+')<CR><cmd>lua vim.notify("Yanked " .. vim.fn.getreg('+'))<CR>]],
						{ noremap = true }
					)
				end,
			})
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		---@module "ibl"
		---@type ibl.config
		-- opts = {},
		config = function()
			vim.opt.listchars = { space = "·", tab = "→ " }
			require("ibl").setup({
				indent = {
					char = "│",
					tab_char = { "│" },
					highlight = { "IblIndent" },
				},
				scope = {
					show_start = true,
					show_end = true,
					char = { "│" },
					show_exact_scope = true,
					highlight = { "IblScope" },
				},
			})
		end,
	},
}
