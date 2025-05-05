-- Styler but my own:
-- Define a namespace for our buffer-specific highlights
local ns_id = vim.api.nvim_create_namespace("filetype_backgrounds")

-- Define background colors for different filetypes
local filetype_backgrounds = {
	markdown = "#4d4d52",
	lua = "#131940",
	terraform = "#2c1734"
}

-- Create a separate namespace for each filetype to avoid conflicts
local namespace_cache = {}
local function get_namespace_for_filetype(filetype)
	if not namespace_cache[filetype] then
		namespace_cache[filetype] = vim.api.nvim_create_namespace("bg_" .. filetype)
		vim.api.nvim_set_hl(namespace_cache[filetype], "Normal", { bg = filetype_backgrounds[filetype] })
	end
	return namespace_cache[filetype]
end

-- Set up autocommands to handle buffer events
local augroup = vim.api.nvim_create_augroup("FiletypeBackgrounds", { clear = true })

-- Apply the appropriate highlight when entering a buffer
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "FileType" }, {
	group = augroup,
	callback = function()
		local bufnr = vim.api.nvim_get_current_buf()
		local winid = vim.api.nvim_get_current_win()
		local filetype = vim.bo[bufnr].filetype

		if filetype_backgrounds[filetype] then
			-- Get namespace for this filetype
			local ns = get_namespace_for_filetype(filetype)

			-- Apply the namespace to this window only
			vim.api.nvim_win_set_hl_ns(winid, ns)

			-- Store the namespace ID in a buffer variable for future reference
			vim.api.nvim_buf_set_var(bufnr, "bg_namespace", ns)
		else
			-- Reset to default highlights for buffers without special background
			vim.api.nvim_win_set_hl_ns(winid, 0)
		end
	end
})

-- Handle window creation/switching to ensure the right highlight is applied
-- vim.api.nvim_create_autocmd("WinEnter", {
-- 	group = augroup,
-- 	callback = function()
-- 		local winid = vim.api.nvim_get_current_win()
-- 		local bufnr = vim.api.nvim_win_get_buf(winid)
-- 		local filetype = vim.bo[bufnr].filetype
--
-- 		if filetype_backgrounds[filetype] then
-- 			-- Try to get the stored namespace for this buffer
-- 			local success, ns = pcall(vim.api.nvim_buf_get_var, bufnr, "bg_namespace")
-- 			if success then
-- 				vim.api.nvim_win_set_hl_ns(winid, ns)
-- 			else
-- 				-- If not found, create a new one
-- 				local ns = get_namespace_for_filetype(filetype)
-- 				vim.api.nvim_win_set_hl_ns(winid, ns)
-- 				vim.api.nvim_buf_set_var(bufnr, "bg_namespace", ns)
-- 			end
-- 		else
-- 			-- Reset to default highlights
-- 			vim.api.nvim_win_set_hl_ns(winid, 0)
-- 		end
-- 	end
-- })

-- -- Ensure windows showing non-special buffers use the default highlight
-- vim.api.nvim_create_autocmd("BufWinEnter", {
-- 	group = augroup,
-- 	callback = function()
-- 		local winid = vim.api.nvim_get_current_win()
-- 		local bufnr = vim.api.nvim_win_get_buf(winid)
-- 		local filetype = vim.bo[bufnr].filetype
--
-- 		if not filetype_backgrounds[filetype] then
-- 			vim.api.nvim_win_set_hl_ns(winid, 0)
-- 		end
-- 	end
-- })
