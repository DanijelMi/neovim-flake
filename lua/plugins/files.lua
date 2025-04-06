return {
	{
		"echasnovski/mini.files",
		version = false,
		lazy = false,
		config = function()
			local MiniFiles = require("mini.files")
			MiniFiles.setup({
				mappings = {
					close = "<Esc>",
					go_in = "l",
					go_in_plus = "L",
					go_out = "h",
					go_out_plus = "H",
					reset = "<BS>",
					reveal_cwd = "@",
					show_help = "g?",
					synchronize = "=",
					trim_left = "<",
					trim_right = ">",
				},
				windows = {
					preview = true,
					width_preview = math.floor(vim.o.columns * 0.8),
				},
			})

			-- Mapping to toggle dot-files
			local show_dotfiles = true
			local filter_show = function(fs_entry)
				return true
			end

			local filter_hide = function(fs_entry)
				return not vim.startswith(fs_entry.name, ".")
			end

			local toggle_dotfiles = function()
				show_dotfiles = not show_dotfiles
				local new_filter = show_dotfiles and filter_show or filter_hide
				MiniFiles.refresh({ content = { filter = new_filter } })
			end

			-- Convenient window splitting
			local map_split = function(buf_id, lhs, direction)
				local rhs = function()
					-- Make new window and set it as target
					local cur_target = MiniFiles.get_explorer_state().target_window
					local new_target = vim.api.nvim_win_call(cur_target, function()
						vim.cmd(direction .. " split")
						return vim.api.nvim_get_current_win()
					end)
					MiniFiles.set_target_window(new_target)
					-- This intentionally doesn't act on file under cursor in favor of
					-- explicit "go in" action (`l` / `L`). To immediately open file,
					-- add appropriate `MiniFiles.go_in()` call instead of this comment.
				end
				-- Adding `desc` will result into `show_help` entries
				local desc = "Split " .. direction
				vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
			end

			-- Open file with external program
			local external_open = function()
				local fs_entry = MiniFiles.get_fs_entry()
				vim.notify("Opening: " .. fs_entry.path .. " externally.")
				vim.ui.open(fs_entry.path)
			end

			-- Set new Current Working Directory
			local set_cwd = function()
				-- Works only if cursor is on the valid file system entry
				local cur_entry_path = MiniFiles.get_fs_entry().path
				local cur_directory = vim.fs.dirname(cur_entry_path)
				-- vim.fn.chdir(cur_directory)
				vim.cmd("tcd " .. vim.fn.fnameescape(cur_directory))
				vim.notify(string.format("'%s' set as CWD (tab-local)", cur_directory))
			end
			--
			-- Yank in register full path of entry under cursor
			local yank_path = function()
				local path = (MiniFiles.get_fs_entry() or {}).path
				if path == nil then
					return vim.notify("Cursor is not on valid entry")
				end
				vim.notify("Copied path: " .. path)
				vim.fn.setreg(vim.v.register, path)
			end

			vim.api.nvim_create_autocmd("User", {
				pattern = "MiniFilesBufferCreate",
				callback = function(args)
					local b = args.data.buf_id
					-- Show dotfile
					vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = b, desc = "Toggle dotfiles" })
					-- Open with external program
					vim.keymap.set("n", "gx", external_open, { buffer = b, desc = "Open file with external program" })
					vim.keymap.set("n", "gy", yank_path, { buffer = b, desc = "Yank path" })
					-- Set new Current Working Directory
					vim.keymap.set("n", "g~", set_cwd, { buffer = b, desc = "Set CWD here (tab-local)" })
					-- Open Terminal Here TODO this feature
					-- vim.keymap.set("n", "gt", open_terminal, { buffer = b, desc = "Open Terminal Here" })
					-- Create binds for quickly creating new splits
					map_split(b, "<C-s>", "belowright horizontal")
					map_split(b, "<C-v>", "belowright vertical")
					map_split(b, "<C-t>", "tab")
				end,
			})
		end,
		keys = {
			{
				"-",
				function()
					-- If current buffer can't be found in filesystem, don't error but open parent dir or cwd
					-- Toggle explorer ~
					local MiniFiles = require("mini.files")
					local minifiles_toggle = function(...)
						if not MiniFiles.close() then
							MiniFiles.open(...)
						end
					end

					local buf_name = vim.api.nvim_buf_get_name(0)
					local dir_name = vim.fn.fnamemodify(buf_name, ":p:h")
					if vim.fn.filereadable(buf_name) == 1 then
						-- Pass the full file path to highlight the file
						minifiles_toggle(buf_name, true, {
							windows = {
								preview = true,
								width_preview = math.floor(vim.o.columns * 0.6),
							},
							-- content = {
							-- 	filter = function()
							-- 		return true
							-- 	end,
							-- },
						})
					elseif vim.fn.isdirectory(dir_name) == 1 then
						-- If the directory exists but the file doesn't, open the directory
						minifiles_toggle(dir_name, true)
					else
						-- If neither exists, fallback to the current working directory
						minifiles_toggle(vim.uv.cwd(), true)
					end
				end,
				mode = "n",
				desc = "Open mini.files from current buffer",
			},
			{
				"<leader>-",
				function()
					require("mini.files").open(nil, false, {
						windows = {
							preview = true,
							width_preview = math.floor(vim.o.columns * 0.6),
						},
					})
				end,
				mode = "n",
				desc = "Open mini.files from CWD",
			},
		},
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- "3rd/image.nvim",           -- Optional image support in preview window: See `# Preview Mode` for more information
		},
		opts = {
			close_if_last_window = true,
			filesystem = {
				hijack_netrw_behavior = "disabled",
				follow_current_file = {
					enabled = true,
				},
			},
		},
		lazy = false,
		keys = {
			{ "<leader>N", "<CMD>Neotree filesystem toggle<CR>", mode = "n", desc = "Toggle Neotree view" },
		},
	},
}
