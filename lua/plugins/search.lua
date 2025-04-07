return {
	{
		"ibhagwan/fzf-lua",
		lazy = false,
		-- optional for icon support
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("fzf-lua").register_ui_select({
				-- "hide", -- Keep the fzf menu buffers in background so that we can use .resume()
			})
		end,
		opts = {},
		keys = {
			{
				"<leader>ff",
				function()
					require("fzf-lua").files()
				end,
				desc = "[F]zflua [f]files",
			},
			{
				"<leader>fg",
				function()
					require("fzf-lua").live_grep()
				end,
				desc = "[F]zflua [g]rep",
			},
			{
				"<leader>fb",
				function()
					require("fzf-lua").buffers()
				end,
				desc = "[F]zflua [b]uffers",
			},
			{
				"<leader>f/",
				function()
					require("fzf-lua").lgrep_curbuf()
				end,
				desc = "[F]zflua [/]Search current buf",
			},
			{
				"<leader>f?",
				function()
					require("fzf-lua").builtin()
				end,
				desc = "[F]zflua [a]ll menus fzf-lua has",
			},
			{
				"<leader>fa",
				function()
					require("fzf-lua").args()
				end,
				desc = "[F]zflua [a]rglist",
			},
			{
				"<leader>fc",
				function()
					require("fzf-lua").colorschemes()
				end,
				desc = "[F]zflua [C]olorschemes",
			},
			{
				"<leader>fm",
				function()
					require("fzf-lua").marks()
				end,
				desc = "[F]zflua [m]arks",
			},
			{
				"<leader>fR",
				function()
					require("fzf-lua").resume()
				end,
				desc = "[F]zflua [R]esume",
			},
			{
				"<leader>fh",
				function()
					require("fzf-lua").oldfiles()
				end,
				desc = "[F]ile [h]istory",
			},
			{
				"<leader>fz",
				function()
					require("fzf-lua").zoxide()
				end,
				desc = "[F]zflua [Z]oxide",
			},
			{
				"<leader>fr",
				function()
					require("fzf-lua").files({
						cmd = "fd --hidden --type d .git$ --exec dirname {}",
					})
				end,
				desc = "[F]zflua Git [r]epositories",
			},
			{
				"<leader>fw",
				function()
					require("fzf-lua").grep_cword()
				end,
				desc = "[F]zflua grep [w]ord",
			},
			{
				"<leader>fW",
				function()
					require("fzf-lua").grep_cWORD()
				end,
				desc = "[F]zflua grep [W]ord",
			},
			{
				"<leader>fnh",
				function()
					require("fzf-lua").helptags()
				end,
				desc = "[F]zflua [n]eovim [h]elp",
			},
			{
				"<leader>fnk",
				function()
					require("fzf-lua").keymaps()
				end,
				desc = "[F]zflua [n]eovim [k]eymaps",
			},
			{
				"<leader>fno",
				function()
					require("fzf-lua").nvim_options()
				end,
				desc = "[F]zflua [n]eovim [o]ptions",
			},
			{
				"<leader>fnc",
				function()
					require("fzf-lua").files({ cwd = vim.fn.stdpath("config") })
				end,
				desc = "[F]zflua [n]eovim [c]onfiguration files",
			},
		},
	},
}
