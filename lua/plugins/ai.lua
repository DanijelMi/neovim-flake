return {
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"ravitemer/mcphub.nvim",
		},
		config = function()
			local default_model = "google/gemini-2.0-flash-001"
			local available_models = {
				"google/gemini-2.0-flash-001",
				"google/gemini-2.5-pro-preview",
				"anthropic/claude-3.7-sonnet",
				"anthropic/claude-3.5-sonnet",
				"openai/gpt-4o-mini",
			}
			local current_model = default_model

			local function select_model()
				vim.ui.select(available_models, {
					prompt = "Select  Model:",
				}, function(choice)
					if choice then
						current_model = choice
						vim.notify("Selected model: " .. current_model)
					end
				end)
			end

			require("codecompanion").setup({
				display = {
					chat = {
						intro_message = "CodeCompanion, ? for opts",
						show_header_separator = false, -- Show header separators in the chat buffer? Set this to false if you're using an external markdown formatting plugin
						show_settings = true,    -- Show LLM settings at the top of the chat buffer
						auto_scroll = false
					},
					action_palette = {
						prompt = "actionpalleteprompt: ",
						provider = "snacks",
					},
				},
				strategies = {
					chat = {
						slash_commands = {
							["file"] = {
								-- Location to the slash command in CodeCompanion
								callback = "strategies.chat.slash_commands.file",
								description = "Select a file using Picker",
								opts = {
									provider = "snacks",
									contains_code = true,
								},
							},
							["git_files"] = {
								description = "List git files",
								---@param chat CodeCompanion.Chat
								callback = function(chat)
									local handle = io.popen("git ls-files")
									if handle ~= nil then
										local result = handle:read("*a")
										handle:close()
										chat:add_reference({ role = "user", content = result }, "git", "<git_files>")
									else
										return vim.notify("No git files available", vim.log.levels.INFO, { title = "CodeCompanion" })
									end
								end,
								opts = {
									contains_code = false,
								},
							},
						},
						adapter = "openrouter",
						keymaps = {
							send = {
								modes = { n = "<C-s>", i = "<C-s>" },
							},
							close = {
								modes = { n = "<C-c>", i = "<C-c>" },
							},
						},
					},
					inline = {
						adapter = "openrouter",
						inline = {
							keymaps = {
								accept_change = {
									modes = { n = "ga" },
									description = "Accept the suggested change",
								},
								reject_change = {
									modes = { n = "gr" },
									description = "Reject the suggested change",
								},
							},
						},
					},
				},
				adapters = {
					http = {
						openrouter = function()
							return require("codecompanion.adapters").extend("openai_compatible", {
								name = "OpenRouter",
								env = {
									url = "https://openrouter.ai/api",
									api_key = os.getenv("OPENROUTER_API_KEY"),
									chat_url = "/v1/chat/completions",
								},
								schema = {
									model = {
										default = current_model,
									},
								},
							})
						end,
					}
				},
				extensions = {
					mcphub = {
						callback = "mcphub.extensions.codecompanion",
						opts = {
							make_vars = true,
							make_slash_commands = true,
							show_result_in_chat = true
						}
					}
				},
				-- Completion source for nvim-cmp or blink.cmp
				sources = {
					per_filetype = {
						codecompanion = { "codecompanion" },
					}
				},
			})

			vim.keymap.set({ "n", "v" }, "<leader>cl", "<cmd>CodeCompanionActions<cr>",
				{ noremap = true, silent = true, desc = "List available CC actions" })
			vim.keymap.set({ "n", "v" }, "<leader>cc", "<cmd>CodeCompanionChat Toggle Chat<cr>",
				{ noremap = true, silent = true, desc = "Toggle CC chat" })
			vim.keymap.set("v", "<leader>ca", "<cmd>CodeCompanionChat Add<cr>",
				{ noremap = true, silent = true, desc = "Add selection to CC" })
			vim.keymap.set("n", "<leader>cs", select_model, { desc = "Select Gemini Model" })
			-- TODO: Open this url on a keybind: https://openrouter.ai/settings/credits
			-- OR just get api lol https://openrouter.ai/docs/api-reference/get-credits and print as vim notification
			-- Expand 'cc' into 'CodeCompanion' in the command line
			vim.cmd([[cab cc CodeCompanion]])
		end,
	},
}
