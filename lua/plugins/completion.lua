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
			require("blink.cmp").setup({
				keymap = {
					["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
					["<C-e>"] = { "hide" },
					["<C-y>"] = { "select_and_accept" },
					["<Up>"] = { "select_prev", "fallback" },
					["<Down>"] = { "select_next", "fallback" },
					["<C-p>"] = { "select_prev", "fallback_to_mappings" },
					["<C-n>"] = { "select_next", "fallback_to_mappings" },
					["<C-b>"] = { "scroll_documentation_up", "fallback" },
					["<C-f>"] = { "scroll_documentation_down", "fallback" },
					["<Tab>"] = { "snippet_forward", "fallback" },
					["<S-Tab>"] = { "snippet_backward", "fallback" },
					["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
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
				},
				completion = {
					list = {
						selection = {
							preselect = false,
							auto_insert = true,
						},
					},
					menu = {
						draw = {
							columns = { { "item_idx" }, { "kind_icon" }, { "label", "label_description", gap = 1 } },
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
					documentation = { auto_show = true },
				},
				fuzzy = {
					implementation = "prefer_rust_with_warning",
				},
				snippets = { preset = "luasnip" },
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
						lazydev = {
							name = "LazyDev",
							module = "lazydev.integrations.blink",
							-- make lazydev completions top priority (see `:h blink.cmp`)
							score_offset = 100,
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
			})
			require("luasnip.loaders.from_vscode").lazy_load()
			-- Terraform works on "terraform" filetype only, extend it to "tf" filetype as well
			require("luasnip").filetype_extend("tf", { "terraform" })
		end,
	},
}
