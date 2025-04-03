return {
	"echasnovski/mini.notify",
	version = false,
	opts = {
		setup = function()
			local MiniNotify = require("mini.notify")
			MiniNotify.setup()
			vim.notify = MiniNotify.make_notify()
		end,
	},
}
