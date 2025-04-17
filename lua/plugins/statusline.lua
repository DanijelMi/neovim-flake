-- Custom bottom bar
return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "auto",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = {},
					winbar = {},
				},
				ignore_focus = {},
				always_divide_middle = true,
				always_show_tabline = false,
				globalstatus = true,
				refresh = {
					statusline = 100,
					tabline = 100,
					winbar = 100,
				},
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = {
					{
						function()
							local session_name = require("auto-session.lib").current_session_name(true)
							return session_name ~= "" and "📌 " .. (session_name or "") or ""
						end,
					},
					{
						function()
							-- Retrieve the arglist
							local arglist = vim.fn.argv()
							-- Format it into a string representation
							local arglist_str = table.concat(arglist, " ")
							-- Return formatted arglist or a placeholder if empty
							return (arglist_str == "[]") and "[No Arglist]" or arglist_str
						end,
					},
					{
						function()
							return "[Y]" .. require("yaml_nvim").get_yaml_key()
						end,
					},
				},
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = { "filename" },
				lualine_b = { "location" },
			},
			tabline = {
				lualine_a = { { "tabs", max_length = vim.o.columns, mode = 2 } },
			},
			winbar = {
				lualine_a = { "filename" },
			},
			inactive_winbar = {
				lualine_a = { "filename" },
			},
			extensions = {},
		})
	end,
}
