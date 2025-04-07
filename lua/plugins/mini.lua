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
		end,
	},
}
