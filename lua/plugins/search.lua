return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			menu = {
				width = vim.api.nvim_win_get_width(0) - 4,
			},
			settings = {
				save_on_toggle = true,
			},
		},
		keys = function()
			local keys = {
				{
					"<leader>H",
					function()
						require("harpoon"):list():add()
					end,
					desc = "Harpoon File",
				},
				{
					"<leader>h",
					function()
						local harpoon = require("harpoon")
						harpoon.ui:toggle_quick_menu(harpoon:list())
					end,
					desc = "Harpoon Quick Menu",
				},
			}
			-- Create 5 binds for jumping to files
			for i = 1, 5 do
				table.insert(keys, {
					"<leader>" .. i,
					function()
						require("harpoon"):list():select(i)
					end,
					desc = "Harpoon to File " .. i,
				})
			end
			return keys
		end,
	},
	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("fzf-lua").setup({
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
				"<leader>fa",
				function()
					require("fzf-lua").builtin()
				end,
				desc = "[F]zflua [a]ll menus fzf-lua has",
			},
			{
				"<leader>fC",
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
				desc = "[F]zflua [n]vim [o]ptions",
			},
			{
				"<leader>fnc",
				function()
					require("fzf-lua").files({ cwd = vim.fn.stdpath("config") })
				end,
				desc = "[F]zflua [n]vim [c]onfiguration files",
			},
		},
	},
}
