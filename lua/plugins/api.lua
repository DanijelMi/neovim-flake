return {
	{
		"mistweaverco/kulala.nvim",
		lazy = true,
		keys = {
			{ "<leader>Rs", function() require("kulala").run() end, desc = "Send request" },
			{ "<leader>Ra", function() require("kulala").run_all() end, desc = "Send all requests" },
			{ "<leader>Rb", function() require("kulala").scratchpad() end, desc = "Open scratchpad" },
		},
		opts = {
			global_keymaps = false,
		},
	},
}
