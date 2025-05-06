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
							local arglist = vim.fn.argv()           -- Retrieve the arglist
							local arglist_str = table.concat(arglist, " ") -- Format it into a string representation
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
				lualine_x = {},
				lualine_y = { "encoding", "fileformat", "filetype" },
				lualine_z = { { "location" }, { "progress" } },
			},
			inactive_sections = {
				lualine_a = { "filename" },
				lualine_b = { "location" },
			},
			tabline = {
				lualine_a = { {
					"tabs",
					max_length = vim.o.columns,
					mode = 2,
					fmt = function(name, context)
						-- Show + if buffer is modified in tab
						local buflist = vim.fn.tabpagebuflist(context.tabnr)
						local winnr = vim.fn.tabpagewinnr(context.tabnr)
						local bufnr = buflist[winnr]
						local mod = vim.fn.getbufvar(bufnr, '&mod')

						-- Shorten home user dir to "~"
						local short_cwd = string.gsub(vim.fn.getcwd(), "^" .. vim.fn.expand("~"), "~")
						return short_cwd .. (mod == 1 and ' +' or '')
					end
				} },
			},
			winbar = {
				lualine_a = {
					{ "filename", file_status = true, newfile_status = true, path = 1 },
				},
				lualine_b = {
					{ "filetype", colored = true, icon_only = true, icon = { align = "left" } },
				},
				lualine_z = { "lsp_status" },
			},
			inactive_winbar = {
				lualine_a = {
					{ "filename", file_status = true, newfile_status = true, path = 1 },
				},
				lualine_b = {
					{ "filetype", colored = true, icon_only = true, icon = { align = "left" } },
				},
				lualine_z = { "lsp_status" },
			},
			extensions = {},
		})
	end,
}
