-- LazyVim bootstrap --
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("vim-options") -- Import vim options
require("terminal") -- All things :terminal
require("lazy").setup("plugins") -- Init lazyvim

-- vim.cmd.colorscheme("catppuccin")

-- Staging zone temporary logic goes here

-- :h DiffOrig, lua version
-- Show unsaved diff for current buffer
vim.api.nvim_create_user_command("DiffOrig", function()
	local scratch_buffer = vim.api.nvim_create_buf(false, true)
	local current_ft = vim.bo.filetype
	vim.cmd("vertical sbuffer" .. scratch_buffer)
	vim.bo[scratch_buffer].filetype = current_ft
	vim.cmd("read ++edit #") -- load contents of previous buffer into scratch_buffer
	vim.cmd.normal('1G"_d_') -- delete extra newline at top of scratch_buffer without overriding register
	vim.cmd.diffthis() -- scratch_buffer
	vim.cmd.wincmd("p")
	vim.cmd.diffthis() -- current buffer
end, {})

-- Arglist
vim.keymap.set(
	"n",
	"<leader>aa",
	":argadd<CR>:argdedupe<CR>",
	{ desc = "Add current file to arglist and deduplicate", silent = true }
)
vim.keymap.set("n", "<leader>ad", ":argdelete<CR>", { desc = "Remove current file from arglist", silent = true })
vim.keymap.set("n", "<leader>a1", ":argu 1<CR>", { desc = "Select first file in arglist", silent = true })
vim.keymap.set("n", "<leader>a2", ":argu 2<CR>", { desc = "Select second file in arglist", silent = true })
vim.keymap.set("n", "<leader>a3", ":argu 3<CR>", { desc = "Select third file in arglist", silent = true })
vim.keymap.set("n", "<leader>a4", ":argu 4<CR>", { desc = "Select fourth file in arglist", silent = true })
vim.keymap.set("n", "<leader>a5", ":argu 5<CR>", { desc = "Select fifth file in arglist", silent = true })
