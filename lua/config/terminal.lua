-- All things :terminal

-- Shorter <C-\> alias for <C-\><C-n>
vim.keymap.set("t", "<C-\\>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.api.nvim_create_autocmd("TermOpen", {
	desc = "Disable line numbers in terminal buffers",
	group = vim.api.nvim_create_augroup("term-disable-line-numbers", { clear = true }),
	callback = function()
		vim.wo.number = false
		vim.wo.relativenumber = false
	end,
})

-- vim.api.nvim_create_autocmd("TermOpen", {
-- 	desc = "Automatically enter insert mode when opening a terminal",
-- 	group = vim.api.nvim_create_augroup("term-open-startinsert", { clear = true }),
-- 	command = "startinsert",
-- })

-- :Te to horizontal split an existing, otherwise a new terminal
vim.api.nvim_create_user_command("Te", function()
	local term_bufnr = nil
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_buf_get_option(bufnr, "buftype") == "terminal" then
			term_bufnr = bufnr
			break
		end
	end
	if term_bufnr then
		vim.cmd("horizontal sbuffer " .. term_bufnr)
	else
		vim.cmd("horizontal terminal")
	end
end, { bang = true })

-- Send a command to a terminal
local function terminal_send(execute, mode)
	local first_terminal_chan = get_first_visible_terminal()
	local command_to_paste
	if mode == "visual" then
		command_to_paste = vim.fn.getreg('"v')
	elseif mode == "line" then
		command_to_paste = vim.fn.getline(".")
	end
	if execute then
		command_to_paste = command_to_paste .. "\n"
	end
	vim.api.nvim_chan_send(first_terminal_chan, command_to_paste)
end

-- Return first terminal channel present, that is visible in a window, in the current tab
local function get_first_visible_terminal()
	local terminal_chans = {}
	local tabpage_wins = vim.api.nvim_tabpage_list_wins(0)
	for _, chan in pairs(vim.api.nvim_list_chans()) do
		if chan["mode"] == "terminal" and chan["pty"] ~= "" then
			for _, win in ipairs(tabpage_wins) do
				if vim.api.nvim_win_get_buf(win) == chan["buffer"] then
					table.insert(terminal_chans, chan)
					break
				end
			end
		end
	end
	table.sort(terminal_chans, function(left, right)
		return left["buffer"] < right["buffer"]
	end)
	return terminal_chans[1] and terminal_chans[1]["id"] or nil
end

-- Opens a terminal with the working directory of the focused buffer
function open_terminal_curbuf()
	-- Get the full path of the currently focused buffer
	local filepath = vim.api.nvim_buf_get_name(0)
	-- Extract the directory from the filepath
	local dir = vim.fn.fnamemodify(filepath, ":p:h")
	-- Check if the directory is valid
	if vim.fn.isdirectory(dir) == 1 then
		local shell = vim.o.shell -- Get the shell Neovim is using
		local cmd = string.format("cd %s && %s", vim.fn.shellescape(dir), shell)
		vim.cmd("terminal " .. cmd)
	else
		print("Failed to find directory for buffer.")
	end
end

-- Keybinds for executing text into a terminal
vim.api.nvim_set_keymap(
	"n",
	"<leader>ta",
	":lua terminal_send(false, 'line')<CR>",
	{ noremap = true, silent = true, desc = "Append current line to the first visible terminal buffer" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>tr",
	":lua terminal_send(true, 'line')<CR>",
	{ noremap = true, silent = true, desc = "Run current line to the first visible terminal buffer" }
)
vim.api.nvim_set_keymap(
	"v",
	"<leader>tr",
	'"vy :<C-u>lua terminal_send(true, "visual")<CR>gv',
	{ noremap = true, silent = true, desc = "Run current selection to the first visible terminal buffer" }
)
vim.api.nvim_set_keymap(
	"v",
	"<leader>ta",
	'"vy :<C-u>lua terminal_send(false, "visual")<CR>gv',
	{ noremap = true, silent = true, desc = "Append current selection to the first visible terminal buffer" }
)
vim.api.nvim_set_keymap("n", "<leader>tt", ":Te<CR>", { noremap = true, silent = true, desc = "Open hsplit terminal" })
vim.api.nvim_set_keymap(
	"n",
	"<leader>tT",
	":lua open_terminal_curbuf()<CR>",
	{ noremap = true, silent = true, desc = "Open hsplit terminal" }
)
