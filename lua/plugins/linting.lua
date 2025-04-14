	return {
		"mfussenegger/nvim-lint",
		-- opts = {
		-- 	linters_by_ft = {
		-- 		markdown = {'vale'},
		-- 	}
		-- },
		opts = {},
		config = function(_, opts)
			tflint = require('lint')
		tflint.linters_by_ft = {
				markdown = {"vale"},
			}
		end,
	}
