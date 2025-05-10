-- :h DiffOrig, lua version
-- Show unsaved diff for current buffer
vim.api.nvim_create_user_command("DiffOrig", function()
	local scratch_buffer = vim.api.nvim_create_buf(false, true)
	local current_ft = vim.bo.filetype
	vim.cmd("vertical topleft sbuffer" .. scratch_buffer)
	vim.bo[scratch_buffer].filetype = current_ft
	vim.cmd("read ++edit #") -- load contents of previous buffer into scratch_buffer
	vim.cmd.normal('1G"_d_') -- delete extra newline at top of scratch_buffer without overriding register
	vim.cmd.diffthis()      -- scratch_buffer
	vim.cmd.wincmd("p")
	vim.cmd.diffthis()      -- current buffer
end, {})

vim.api.nvim_set_keymap("n", "<leader>dt", ":diffthis<CR>", { noremap = true, silent = true, desc = "Start diff mode" })
vim.api.nvim_set_keymap("n", "<leader>dc", ":diffoff<CR>", { noremap = true, silent = true, desc = "Close diff mode" })
vim.api.nvim_set_keymap(
	"n",
	"<leader>de",
	":DiffOrig<CR>",
	{ noremap = true, silent = true, desc = "View unsaved diff" }
)
