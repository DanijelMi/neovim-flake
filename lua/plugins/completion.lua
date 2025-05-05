return {
	{
		"saghen/blink.cmp",
		dependencies = {
			{
				"L3MON4D3/LuaSnip", -- Advanced Snippet Framework, does not come with any snippets
				version = "v2.*",
				dependencies = {
					"rafamadriz/friendly-snippets", -- Provides OOTB Snippets for a lot of langs
				},
			},
			{
				"Kaiser-Yang/blink-cmp-dictionary", -- Enables locally provided word dictionaries as source
				dependencies = { "nvim-lua/plenary.nvim" },
			},
		},
		-- use a release tag to download pre-built binaries
		version = "*",
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		config = function()
			-- altkeys are separate since they are reused in command mode keymaps
			local altkeys = {
				-- Select Nth item from the list
				["<A-1>"] = {
					function(cmp)
						cmp.accept({ index = 1 })
					end,
				},
				["<A-2>"] = {
					function(cmp)
						cmp.accept({ index = 2 })
					end,
				},
				["<A-3>"] = {
					function(cmp)
						cmp.accept({ index = 3 })
					end,
				},
				["<A-4>"] = {
					function(cmp)
						cmp.accept({ index = 4 })
					end,
				},
				["<A-5>"] = {
					function(cmp)
						cmp.accept({ index = 5 })
					end,
				},
				["<A-6>"] = {
					function(cmp)
						cmp.accept({ index = 6 })
					end,
				},
				["<A-7>"] = {
					function(cmp)
						cmp.accept({ index = 7 })
					end,
				},
				["<A-8>"] = {
					function(cmp)
						cmp.accept({ index = 8 })
					end,
				},
				["<A-9>"] = {
					function(cmp)
						cmp.accept({ index = 9 })
					end,
				},
				["<A-0>"] = {
					function(cmp)
						cmp.accept({ index = 10 })
					end,
				},
			}
			require("blink.cmp").setup({
				-- wrap in fuction to merge altkeys with normal keymaps
				appearance = {
					use_nvim_cmp_as_default = true,
					nerd_font_variant = "mono",
				},
				keymap = (function()
					local keymap = {
						-- ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
						["<C-space>"] = {}, -- disable from a preset
						["<C-e>"] = { "cancel" },
						["<C-y>"] = { "select_and_accept" },
						["<Up>"] = { "select_prev", "fallback" },
						["<Down>"] = { "select_next", "fallback" },
						["<C-p>"] = { "select_prev", "fallback_to_mappings" },
						["<C-n>"] = { "show_and_insert", "select_next", "fallback_to_mappings" },
						["<C-b>"] = { "scroll_documentation_up", "fallback" },
						["<C-f>"] = { "scroll_documentation_down", "fallback" },
						["<Tab>"] = { "snippet_forward", "fallback" },
						["<S-Tab>"] = { "snippet_backward", "fallback" },
						["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
					}
					-- Append altkeys into the keymap
					for k, v in pairs(altkeys) do
						keymap[k] = v
					end
					return keymap
				end)(),
				completion = {
					list = {
						selection = {
							preselect = true,
							auto_insert = true,
						},
					},
					menu = {
						draw = {
							columns = {
								{ "item_idx" },
								{ "kind" },
								{ "kind_icon" },
								{ "label",      "label_description", gap = 1 },
								{ "source_name" },
							},
							components = {
								item_idx = {
									text = function(ctx)
										return ctx.idx == 10 and "0" or ctx.idx >= 10 and " " or tostring(ctx.idx)
									end,
									highlight = "BlinkCmpItemIdx", -- optional, only if you want to change its color
								},
							},
						},
					},
					documentation = { auto_show = true, auto_show_delay_ms = 0 },
					ghost_text = { enabled = true },
				},
				-- Experimental signature help support
				signature = {
					enabled = true,
					trigger = {
						enabled = true,
						show_on_keyword = true,
					},
				},
				fuzzy = {
					implementation = "prefer_rust_with_warning",
				},
				snippets = { preset = "luasnip", score_offset = 20 },
				-- :checkhealth blink.cmp to see all available sources
				sources = {
					default = {
						"lazydev", -- from folke/lazydev.nvim
						"lsp",
						"snippets", -- snippets
						"path", -- Rel and Abs file paths
						"buffer", -- Text from all VISIBLE OPEN NORMAL buffers
						"dictionary",
						"omni",
					},
					per_filetype = {
						sql = { "snippets", "dadbod", "buffer" },
					},
					providers = {
						lsp = {
							name = "LSP",
							module = "blink.cmp.sources.lsp",
							opts = {}, -- Passed to the source directly, varies by source
							--- NOTE: All of these options may be functions to get dynamic behavior
							--- See the type definitions for more information
							enabled = true,    -- Whether or not to enable the provider
							async = false,     -- Whether we should show the completions before this provider returns, without waiting for it
							timeout_ms = 1000, -- How long to wait for the provider to return before showing completions and treating it as asynchronous
							transform_items = nil, -- Function to transform the items before they're returned
							should_show_items = true, -- Whether or not to show the items
							max_items = nil,   -- Maximum number of items to display in the menu
							min_keyword_length = 0, -- Minimum number of characters in the keyword to trigger the provider
							-- If this provider returns 0 items, it will fallback to these providers.
							-- If multiple providers fallback to the same provider, all of the providers must return 0 items for it to fallback
							fallbacks = {},
							score_offset = 30, -- Boost/penalize the score of the items
							override = nil, -- Override the source's functions
						},
						lazydev = {
							name = "LazyDev",
							module = "lazydev.integrations.blink",
							-- make lazydev completions top priority (see `:h blink.cmp`)
							score_offset = 100,
						},
						path = {
							score_offset = 60,
						},
						dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
						dictionary = {
							module = "blink-cmp-dictionary",
							name = "Dict",
							score_offset = -20,
							-- Make sure this is at least 2.
							-- 3 is recommended
							min_keyword_length = 3,
							-- https://github.com/dwyl/english-words
							opts = {
								dictionary_directories = { vim.fn.stdpath("config") .. "/lua/config/dicts" },
							},
						},
					},
				},
				cmdline = {
					enabled = true,
					keymap = (function()
						-- Create the base keymap with a preset key
						local base_keymap = { preset = "cmdline" }
						-- Looping through altkeys to append into the keymap
						for k, v in pairs(altkeys) do
							base_keymap[k] = v
						end
						return base_keymap -- Return the fully constructed keymap
					end)(),
					sources = function()
						local type = vim.fn.getcmdtype()
						-- Search forward and backward
						if type == "/" or type == "?" then
							return { "buffer" }
						end
						-- Commands
						if type == ":" or type == "@" then
							return { "cmdline" }
						end
						return {}
					end,
					completion = {
						list = {
							selection = { preselect = true, auto_insert = true },
						},
						menu = {
							auto_show = true,
							draw = {
								columns = {
									{ "item_idx" },
									{ "kind_icon" },
									{ "label",    "label_description", gap = 1 },
								},
							},
						},
						ghost_text = { enabled = true },
					},
				},
			})
			require("luasnip.loaders.from_vscode").lazy_load()                  -- Loads friendly-snippets
			require("luasnip.loaders.from_vscode").load({ paths = "./snippets/" }) -- dir relative to $MYVIMRC
		end,
	},
}
