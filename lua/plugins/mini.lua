return {
	{
		"echasnovski/mini.nvim",
		version = false,
		config = function()
			-- Notification GUI top right
			vim.notify = require("mini.notify").make_notify()
			-- Auto-close brackets, quotes, etc.
			require("mini.pairs").setup()
			-- surround objects with '"({[ etc
			require("mini.surround").setup()
			-- Highlight specific strings
			local hipatterns = require("mini.hipatterns")
			hipatterns.setup({
				highlighters = {
					fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
					hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
					todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
					note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
					-- Highlight hex color strings (`#rrggbb`) using that color
					hex_color = hipatterns.gen_highlighter.hex_color(),
				},
			})
			local miniclue = require("mini.clue")
			miniclue.setup({
				triggers = {
					-- Leader triggers
					{ mode = "n", keys = "<Leader>" },
					{ mode = "x", keys = "<Leader>" },

					-- Brackets
					{ mode = "n", keys = "]" },
					{ mode = "n", keys = "[" },

					-- Built-in completion
					{ mode = "i", keys = "<C-x>" },

					-- `g` key
					{ mode = "n", keys = "g" },
					{ mode = "x", keys = "g" },

					-- Marks
					{ mode = "n", keys = "'" },
					{ mode = "n", keys = "`" },
					{ mode = "x", keys = "'" },
					{ mode = "x", keys = "`" },

					-- Registers
					{ mode = "n", keys = '"' },
					{ mode = "x", keys = '"' },
					{ mode = "i", keys = "<C-r>" },
					{ mode = "c", keys = "<C-r>" },

					-- Window commands
					{ mode = "n", keys = "<C-w>" },

					-- `z` key
					{ mode = "n", keys = "z" },
					{ mode = "x", keys = "z" },
				},

				clues = {
					miniclue.gen_clues.builtin_completion(),
					miniclue.gen_clues.g(),
					miniclue.gen_clues.marks(),
					miniclue.gen_clues.registers(),
					miniclue.gen_clues.windows(),
					miniclue.gen_clues.z(),
					-- Enhance this by adding descriptions for <Leader> mapping groups
					{ mode = "n", keys = "<Leader>a", desc = "+Arglist" },
					{ mode = "n", keys = "<Leader>f", desc = "+FzfLua" },
					{ mode = "n", keys = "<Leader>fn", desc = "+Neovim" },
					{ mode = "n", keys = "<Leader>s", desc = "+Session" },
					{ mode = "n", keys = "<Leader>t", desc = "+Terminal" },

					-- Postkey example, after hitting the sequence it will emulate the postkey
					{ mode = "n", keys = "]b", postkeys = "]" },
					{ mode = "n", keys = "]w", postkeys = "]" },
					{ mode = "n", keys = "[b", postkeys = "[" },
					{ mode = "n", keys = "[w", postkeys = "[" },
				},
				window = {
					config = { anchor = "SW", row = "auto", col = "auto", width = "auto" },
					delay = 600,
				},
			})
			require("mini.visits").setup()
		end,
	},
}
