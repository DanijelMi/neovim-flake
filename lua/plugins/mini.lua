return {
	{
		"echasnovski/mini.nvim",
		version = false,
		config = function()
			-- Notification GUI top right
			vim.notify = require("mini.notify").make_notify()
			-- surround objects with '"({[ etc
			require("mini.surround").setup()
		end,
	},
}
