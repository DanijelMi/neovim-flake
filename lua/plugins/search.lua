---@diagnostic disable: undefined-field, undefined-global
return {
	-- Snacks.picker
	{
		"folke/snacks.nvim",
		opts = {
			picker = {
				ui_select = true, -- replace `vim.ui.select` with the snacks picker
				sources = {
					-- Custom source for directory browsing
					dirs = {
						finder = "proc",
						cmd = "fd",
						args = { "--type", "d" },
						transform = function(item)
							item.file = item.text
							item.dir = true
						end,
					},
				},
			},
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
			{
				"<leader>fC",
				function()
					Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
				end,
				desc = "Find Config File",
			},
			{
				"<leader>fd",
				function()
					Snacks.picker.dirs({
						cwd = vim.fn.getcwd(),
						cmd = "fd",
						args = { ".", "--type", "directory" },
						title = "Directory Search",
						win = {
							preview = {
								wo = { number = false },
								title = "{preview}",
								title_pos = "left",
							},
						},
					})
				end,
				desc = "Search Directories",
			},
			{
				"<leader>fcc",
				function()
					Snacks.picker.colorschemes({
						layout = { preset = "right", preview = "minimal" },
					})
				end,
				desc = "All colorschemes",
			},
			{
				"<leader>fcl",
				function()
					Snacks.picker.colorschemes({
						layout = { preset = "right", preview = "minimal" },
						transform = function(item)
							local favorite_themes = {
								"catppuccin-latte",
								"rose-dawn",
								"everforest",
								"kanagawa-lotus",
								"dayfox",
								"dawnfox",
								"tokyonight-day",
							}
							for _, theme in ipairs(favorite_themes) do
								if item.text == theme then
									return item
								end
							end
							return false
						end,
					})
				end,
				desc = "Favorite light colorschemes",
			},
			{
				"<leader>fcd",
				function()
					Snacks.picker.colorschemes({
						layout = { preset = "right", preview = "minimal" },
						transform = function(item)
							local favorite_themes = {
								"catppuccin-mocha",
								"catppuccin-frappe",
								"catppuccin-macchiato",
								"rose-pine-main",
								"rose-pine-moon",
								"kanagawa-wave",
								"kanagawa-dragon",
								"duskfox",
								"nordfox",
								"terafox",
								"nightfox",
								"carbonfox",
								"tokyonight-moon",
								"tokyonight-night",
								"tokyonight-storm",
							}
							for _, theme in ipairs(favorite_themes) do
								if item.text == theme then
									return item
								end
							end
							return false
						end,
					})
				end,
				desc = "Favorite dark colorschemes",
			},
			{
				"<leader>fR",
				function()
					Snacks.picker.dirs({
						cwd = vim.fn.getcwd(),
						cmd = "fd",
						args = { "--hidden", "--type", "directory", ".git$", "--exec", "dirname", "{}" },
						title = "Local Git Repositories",
						win = {
							preview = {
								wo = { number = false },
								title = "{preview}",
								title_pos = "left",
							},
						},
					})
				end,
				desc = "Search Local Repositories",
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
				"<leader>f`",
				function()
					Snacks.picker.resume()
				end,
				desc = "Resume",
			},
			-- git
			{
				"<leader>gb",
				function()
					Snacks.picker.git_branches({
						all = true,
						-- The default "git_branch" format truncates branch names, so I'm keeping it simple
						format = "text",
					})
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
			{
				"<leader>fm",
				function()
					Snacks.picker.marks()
				end,
				desc = "Marks",
			},
			{
				"<leader>fP",
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
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		---@diagnostic disable-next-line: missing-fields
		opts = {
			modes = {
				enabled = true, -- Enable flash / search by default
			},
			char = {
				jump_labels = true,
				multi_line = false,
			},
		},
		-- stylua: ignore
		keys = {
			{
				"<leader>J",
				mode = { "n" },
				function()
					vim.notify("Flash Search toggled " .. tostring(require("flash").toggle()))
				end,
				desc = "Toggle Flash Search"
			},
		},
	},
}
