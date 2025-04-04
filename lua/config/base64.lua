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
