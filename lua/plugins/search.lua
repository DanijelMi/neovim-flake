return {
	{
		"ibhagwan/fzf-lua",
		enabled = false,
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
	{
		"folke/snacks.nvim",
		opts = {
			picker = {},
		},
		keys = {
			{
				"<leader>fF",
				function()
					Snacks.picker.files()
				end,
				desc = "Find Files",
			},
			{
				"<leader>ff",
				function()
					Snacks.picker.smart()
				end,
				desc = "Frecency Find Files",
			},
			-- Grep
			{
				"<leader>fg",
				function()
					Snacks.picker.grep()
				end,
				desc = "Grep",
			},
			-- {
			-- 	"<leader>fG",
			-- 	function()
			-- 		Snacks.picker.grep_buffers()
			-- 	end,
			-- 	desc = "Grep Open Buffers",
			-- },
			{
				"<leader>fb",
				function()
					Snacks.picker.buffers()
				end,
				desc = "Buffers",
			},
			{
				"<leader>f?",
				function()
					Snacks.picker()
				end,
				desc = "All Pickers",
			},
			{
				"<leader>:",
				function()
					Snacks.picker.command_history()
				end,
				desc = "Command History",
			},
			-- {
			-- 	"<leader>n",
			-- 	function()
			-- 		Snacks.picker.notifications()
			-- 	end,
			-- 	desc = "Notification History",
			-- },
			-- find
			{
				"<leader>fc",
				function()
					Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
				end,
				desc = "Find Config File",
			},
			{
				"<leader>fp",
				function()
					Snacks.picker.projects()
				end,
				desc = "Projects",
			},
			{
				"<leader>fr",
				function()
					Snacks.picker.recent()
				end,
				desc = "Recent",
			},
			{
				"<leader>fm",
				function()
					Snacks.picker.marks()
				end,
				desc = "Marks",
			},
			{
				"<leader>fR",
				function()
					Snacks.picker.resume()
				end,
				desc = "Resume",
			},
			-- git
			{
				"<leader>gb",
				function()
					Snacks.picker.git_branches()
				end,
				desc = "Git Branches",
			},
			{
				"<leader>gl",
				function()
					Snacks.picker.git_log()
				end,
				desc = "Git Log",
			},
			{
				"<leader>gL",
				function()
					Snacks.picker.git_log_line()
				end,
				desc = "Git Log Line",
			},
			{
				"<leader>gs",
				function()
					Snacks.picker.git_status()
				end,
				desc = "Git Status",
			},
			{
				"<leader>gS",
				function()
					Snacks.picker.git_stash()
				end,
				desc = "Git Stash",
			},
			{
				"<leader>gd",
				function()
					Snacks.picker.git_diff()
				end,
				desc = "Git Diff (Hunks)",
			},
			{
				"<leader>gf",
				function()
					Snacks.picker.git_log_file()
				end,
				desc = "Git Log File",
			},
			{
				"<leader>/",
				function()
					Snacks.picker.lines()
				end,
				desc = "Buffer Lines",
			},
			{
				"<leader>sg",
				function()
					Snacks.picker.grep()
				end,
				desc = "Grep",
			},
			{
				"<leader>fw",
				function()
					Snacks.picker.grep_word()
				end,
				desc = "Visual selection or word",
				mode = { "n", "x" },
			},
			-- search
			{
				'<leader>f"',
				function()
					Snacks.picker.registers()
				end,
				desc = "Registers",
			},
			{
				"<leader>f/",
				function()
					Snacks.picker.search_history()
				end,
				desc = "Search History",
			},
			{
				"<leader>f:",
				function()
					Snacks.picker.commands()
				end,
				desc = "Commands",
			},
			-- {
			-- 	"<leader>sd",
			-- 	function()
			-- 		Snacks.picker.diagnostics()
			-- 	end,
			-- 	desc = "Diagnostics",
			-- },
			-- {
			-- 	"<leader>sD",
			-- 	function()
			-- 		Snacks.picker.diagnostics_buffer()
			-- 	end,
			-- 	desc = "Buffer Diagnostics",
			-- },
			{
				"<leader>fh",
				function()
					Snacks.picker.help()
				end,
				desc = "Help Pages",
			},
			{
				"<leader>fH",
				function()
					Snacks.picker.highlights()
				end,
				desc = "Highlights",
			},
			{
				"<leader>I",
				function()
					Snacks.picker.icons()
				end,
				desc = "Icons",
			},
			{
				"<leader>sj",
				function()
					Snacks.picker.jumps()
				end,
				desc = "Jumps",
			},
			{
				"<leader>fk",
				function()
					Snacks.picker.keymaps()
				end,
				desc = "Keymaps",
			},
			-- {
			-- 	"<leader>sl",
			-- 	function()
			-- 		Snacks.picker.loclist()
			-- 	end,
			-- 	desc = "Location List",
			-- },
			{
				"<leader>fm",
				function()
					Snacks.picker.marks()
				end,
				desc = "Marks",
			},
			{
				"<leader>fp",
				function()
					Snacks.picker.lazy()
				end,
				desc = "Search for Plugin Spec",
			},
			{
				"<leader>fq",
				function()
					Snacks.picker.qflist()
				end,
				desc = "Quickfix List",
			},
			{
				"<leader>fu",
				function()
					Snacks.picker.undo()
				end,
				desc = "Undo History",
			},
			{
				"<leader>fC",
				function()
					Snacks.picker.colorschemes()
				end,
				desc = "Colorschemes",
			},
			-- LSP
			-- {
			-- 	"gd",
			-- 	function()
			-- 		Snacks.picker.lsp_definitions()
			-- 	end,
			-- 	desc = "Goto Definition",
			-- },
			-- {
			-- 	"gD",
			-- 	function()
			-- 		Snacks.picker.lsp_declarations()
			-- 	end,
			-- 	desc = "Goto Declaration",
			-- },
			-- {
			-- 	"gr",
			-- 	function()
			-- 		Snacks.picker.lsp_references()
			-- 	end,
			-- 	nowait = true,
			-- 	desc = "References",
			-- },
			-- {
			-- 	"gI",
			-- 	function()
			-- 		Snacks.picker.lsp_implementations()
			-- 	end,
			-- 	desc = "Goto Implementation",
			-- },
			-- {
			-- 	"gy",
			-- 	function()
			-- 		Snacks.picker.lsp_type_definitions()
			-- 	end,
			-- 	desc = "Goto T[y]pe Definition",
			-- },
			-- {
			-- 	"<leader>ss",
			-- 	function()
			-- 		Snacks.picker.lsp_symbols()
			-- 	end,
			-- 	desc = "LSP Symbols",
			-- },
			-- {
			-- 	"<leader>sS",
			-- 	function()
			-- 		Snacks.picker.lsp_workspace_symbols()
			-- 	end,
			-- 	desc = "LSP Workspace Symbols",
			-- },
		},
	},
}
