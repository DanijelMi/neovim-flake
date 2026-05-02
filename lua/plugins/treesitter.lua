return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main", -- main = nvim 0.12+ compatible API (full rewrite); master is locked for nvim 0.11
		lazy = false,
		build = ":TSUpdate",
		config = function()
			-- To install parsers: :TSInstall <lang>  (requires tree-sitter CLI in PATH)
			-- To update all installed parsers: :TSUpdate
			-- Parsers are stored in stdpath('data')/site/parser/ (main branch default)

			-- Ensure parsers for commonly used languages are installed
			require("nvim-treesitter").install({
				"bash",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"nix",
				"python",
				"terraform",
				"yaml",
			})

			-- Enable treesitter highlighting for all filetypes, skipping large files
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					local max_filesize = 100 * 1024 -- 100 KB
					local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
					if ok and stats and stats.size > max_filesize then
						return
					end
					pcall(vim.treesitter.start)
				end,
			})

			-- Indentation based on treesitter for the = operator
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "*" },
				callback = function()
					if vim.bo.filetype ~= "ruby" then
						vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main", -- keep in sync with nvim-treesitter main branch
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = {
					lookahead = true,
					selection_modes = {
						["@parameter.outer"] = "v", -- charwise
						["@function.outer"] = "V", -- linewise
						["@class.outer"] = "<c-v>", -- blockwise
					},
					include_surrounding_whitespace = true,
				},
			})

			local ts_select = require("nvim-treesitter-textobjects.select")
			vim.keymap.set({ "x", "o" }, "af", function()
				ts_select.select_textobject("@function.outer", "textobjects")
			end, { desc = "Select outer function" })
			vim.keymap.set({ "x", "o" }, "if", function()
				ts_select.select_textobject("@function.inner", "textobjects")
			end, { desc = "Select inner function" })
			vim.keymap.set({ "x", "o" }, "ac", function()
				ts_select.select_textobject("@class.outer", "textobjects")
			end, { desc = "Select outer class" })
			vim.keymap.set({ "x", "o" }, "ic", function()
				ts_select.select_textobject("@class.inner", "textobjects")
			end, { desc = "Select inner part of a class region" })
			vim.keymap.set({ "x", "o" }, "as", function()
				ts_select.select_textobject("@local.scope", "locals")
			end, { desc = "Select language scope" })
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("treesitter-context").setup({
				enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
				multiwindow = false, -- Enable multiwindow support.
				max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
				min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
				line_numbers = true,
				multiline_threshold = 20, -- Maximum number of lines to show for a single context
				trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
				mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
				-- Separator between context and content. Should be a single character string, like '-'.
				-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
				separator = nil,
				zindex = 20, -- The Z-index of the context window
				on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
			})
		end,
	},
}
