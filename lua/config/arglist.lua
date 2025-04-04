-- Arglist - native replacement to jump-like plugins
-- https://github.com/cbochs/grapple.nvim
-- https://github.com/otavioschwanck/arrow.nvim
-- https://github.com/ThePrimeagen/harpoon/tree/harpoon2
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
