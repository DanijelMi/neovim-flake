return {
	{
		"monaqa/dial.nvim",
		config = function()
			-- Keymaps
			local dialmap = require("dial.map")
			vim.keymap.set("n", "<C-a>", function()
				dialmap.manipulate("increment", "normal")
			end)
			vim.keymap.set("n", "<C-x>", function()
				dialmap.manipulate("decrement", "normal")
			end)
			vim.keymap.set("n", "g<C-a>", function()
				dialmap.manipulate("increment", "gnormal")
			end)
			vim.keymap.set("n", "g<C-x>", function()
				dialmap.manipulate("decrement", "gnormal")
			end)
			vim.keymap.set("v", "<C-a>", function()
				dialmap.manipulate("increment", "visual")
			end)
			vim.keymap.set("v", "<C-x>", function()
				dialmap.manipulate("decrement", "visual")
			end)
			vim.keymap.set("v", "g<C-a>", function()
				dialmap.manipulate("increment", "gvisual")
			end)
			vim.keymap.set("v", "g<C-x>", function()
				dialmap.manipulate("decrement", "gvisual")
			end)

			-- Augends
			local augend = require("dial.augend")
			require("dial.config").augends:register_group({
				default = {
					augend.integer.alias.hex,
					augend.integer.alias.octal,
					augend.integer.alias.binary,
					augend.integer.alias.decimal_int,
					augend.constant.alias.en_weekday_full,
					augend.constant.new({
						elements = { "false", "true" },
						word = true,
						cyclic = true,
						preserve_case = true,
					}),
					augend.constant.new({
						elements = { "left", "right" },
						word = true,
						cyclic = true,
						preserve_case = true,
					}),
					augend.constant.new({
						elements = { "up", "down" },
						word = true,
						cyclic = true,
						preserve_case = true,
					}),
					augend.constant.new({
						elements = { "north", "east", "south", "west" },
						word = true,
						cyclic = true,
						preserve_case = true,
					}),
					augend.constant.new({
						elements = { "and", "or" },
						word = true,
						cyclic = true,
						preserve_case = true,
					}),
					augend.constant.new({
						elements = { "no", "yes" },
						word = true,
						cyclic = true,
						preserve_case = true,
					}),
				},
			})
		end,
	},
	{
		"ovk/endec.nvim",
		event = "VeryLazy",
		opts = {
			keymaps = {
				defaults = false, -- disable all default binds
				encode_base64_inplace = "gbe",
				vencode_base64_inplace = "gbe",
				decode_base64_inplace = "gbd",
				vdecode_base64_inplace = "gbd",
			},
		},
	},
}
