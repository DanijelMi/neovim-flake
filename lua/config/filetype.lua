-- Override the default more nuanced rule, just evaluate based off of extension
vim.filetype.add({
	extension = {
		tf = "terraform",
	},
})

-- Disable visible space characters on markdown files
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.opt_local.listchars = { space = " " }
	end,
})
