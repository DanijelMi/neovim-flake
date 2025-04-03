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

vim.cmd.colorscheme("tokyonight-storm")

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

-- Base64
-- Maybe switch to https://github.com/ovk/endec.nvim

-- Function to handle base64 encoding or decoding based on a given operation
local function base64_transform(operation)
	-- Retrieve visual selection start and end
	local _, start_line, start_col, _ = unpack(vim.fn.getpos("'<"))
	local _, end_line, end_col, _ = unpack(vim.fn.getpos("'>"))
	-- Get the lines of the visual selection (inclusive)
	local selected_lines = vim.fn.getline(start_line, end_line)
	-- Adjust columns to zero-based index for Lua string operations
	start_col = start_col - 1
	end_col = end_col - 1

	-- Handle transformation
	if #selected_lines == 1 then
		-- Single-line transformation
		local line = selected_lines[1]
		selected_lines[1] = line:sub(1, start_col)
			.. operation(line:sub(start_col + 1, end_col + 1))
			.. line:sub(end_col + 2)
	else
		-- Multi-line transformation
		selected_lines[1] = selected_lines[1]:sub(1, start_col) .. operation(selected_lines[1]:sub(start_col + 1))
		selected_lines[#selected_lines] = operation(selected_lines[#selected_lines]:sub(1, end_col + 1))
			.. selected_lines[#selected_lines]:sub(end_col + 2)
		for i = 2, #selected_lines - 1 do
			selected_lines[i] = operation(selected_lines[i])
		end
	end

	-- Set the transformed lines back in the buffer
	vim.fn.setline(start_line, selected_lines)

	-- Reselect the transformed area
	vim.fn.execute("normal! gv")
end

-- Function for base64 encoding using Neovim's native function
function Base64Encode()
	base64_transform(vim.base64.encode)
end

-- Function for base64 decoding using Neovim's native function
function Base64Decode()
	base64_transform(vim.base64.decode)
end

-- Command definitions sensitize to ranges, including visual mode
vim.api.nvim_create_user_command("B64Enc", Base64Encode, { range = true })
vim.api.nvim_create_user_command("B64Dec", Base64Decode, { range = true })
