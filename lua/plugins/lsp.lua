return {
	{
		-- Configures Lua LSP for Neovim specific apis etc., also provides a completion source
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		-- Quickstart configs for Nvim LSP
		"neovim/nvim-lspconfig",
		dependencies = "saghen/blink.cmp",
		config = function()
			-- Diagnostic Config
			-- See :help vim.diagnostic.Opts
			vim.diagnostic.config({
				severity_sort = true,
				update_in_insert = false,
				float = { border = "rounded", source = true },
				underline = { severity = { min = vim.diagnostic.severity.WARN } },
				signs = vim.g.have_nerd_font and {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚",
						[vim.diagnostic.severity.WARN] = "󰀪",
						[vim.diagnostic.severity.INFO] = "󰋽",
						[vim.diagnostic.severity.HINT] = "󰌶",
					},
				} or {},
				virtual_text = false,
				virtual_lines = { current_line = true },
			})

			-- Toggle all diagnostics
			vim.keymap.set(
				"n",
				"<leader>td",
				"<cmd>lua vim.diagnostic.enable(not vim.diagnostic.is_enabled())<cr>",
				{ desc = "Toggle diagnostics" }
			)

			local lspconfig = require("lspconfig")
			-- - LSP servers and clients are able to communicate to each other what features they support.
			--  By default, Neovim doesn't support everything that is in the LSP specification.
			--  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
			--  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
		local capabilities = require("blink.cmp").get_lsp_capabilities()
		-- Apply blink.cmp capabilities to all LSP servers globally
		vim.lsp.config('*', { capabilities = capabilities })

		-- Lua
		vim.lsp.enable('lua_ls')
		vim.lsp.config('lua_ls', {
			filetypes = { 'lua' },
			settings = {
				Lua = {
					runtime = {
						version = 'LuaJIT',
					},
					hint = {
						enable = true
					}
				}
			}
		})
			-- Nix
			vim.lsp.enable('nixd')
			-- Markdown
			vim.lsp.enable('marksman')
			-- Terraform
			vim.lsp.enable('terraformls')
			-- OpenTofu
			vim.lsp.config('tofu_ls', {
				cmd = {'tofu-ls', 'serve'},
				filetypes = {'terraform', 'terraform-vars'},
				root_markers = { '.terraform', '.git'},
			})
			vim.lsp.enable('tofu_ls')
			vim.lsp.enable('tflint')
			-- Bash
			vim.lsp.enable('bashls')
			-- Python
			vim.lsp.enable('basedpyright')
			-- Grammar
			vim.lsp.enable('harper_ls')
			vim.lsp.config('harper_ls', {
				filetypes = { "markdown", "text" },
			})
			-- JSON
			vim.lsp.enable('jsonls')
			vim.lsp.config('jsonls', {
				schemas = require("schemastore").json.schemas(),
				validate = { enable = true }
			})
			-- YAML
			vim.lsp.enable('yamlls')
			vim.lsp.config('yamlls', {
				settings = {
					yaml = {
						schemaStore = {
							-- Disable built-in schemaStore fetching, we are relying on schemastore plugin
							enable = false,
							-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
							url = "",
						},
						schemas = require("schemastore").yaml.schemas(),
					},
				},
			})
			-- Gitlab (depends on yamlls + gitlab schema)
			vim.lsp.enable('gitlab_ci_ls')
			-- -- PostgreSQL
			vim.lsp.enable('postgres_lsp')

			-- vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, { desc = "LSP: Show diagnostic" })
			-- vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, { desc = "LSP: setloclist" })
			-- vim.keymap.set("n", "<space>k", vim.lsp.buf.hover, { desc = "LSP: hover" })

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					-- In this case, we create a function that lets us more easily define mappings specific
					-- for LSP related items. It sets the mode, buffer and description for us each time.
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
					---@param client vim.lsp.Client
					---@param method vim.lsp.protocol.Method
					---@param bufnr? integer some lsp support methods only in specific files
					---@return boolean
					local function client_supports_method(client, method, bufnr)
						return client:supports_method(method, bufnr)
					end

					-- highlight references of the word under your cursor when your cursor rests there for a little while.
					--    See `:help CursorHold` for information about when this is executed
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if
							client
							and client_supports_method(
								client,
								vim.lsp.protocol.Methods.textDocument_documentHighlight,
								event.buf
							)
					then
						local highlight_augroup =
								vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})
						-- When you move your cursor, the highlights will be cleared
						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})
						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					-- The following code creates a keymap to toggle inlay hints in your
					-- code, if the language server you are using supports them
					-- This may be unwanted, since they displace some of your code
					if
							client
							and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
					then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})
		end,
	},
	{
		"rachartier/tiny-code-action.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{
				"folke/snacks.nvim",
			},
		},
		event = "LspAttach",
		opts = {
			backend = "difftastic",
			picker = { "snacks" },
			backend_opts = {
				delta = {
					header_lines_to_remove = 0,
					args = {
						"--line-numbers",
					},
				},
				difftastic = {
					header_lines_to_remove = 0,
					args = {
						"--color=always",
						"--display=inline",
						"--syntax-highlight=on",
					},
				},
			},
		},
		keys = {
			{
				"gra",
				function()
					require("tiny-code-action").code_action({})
				end,
				desc = "tiny-code-action: Code Action",
			},
		},
	},
	{
		-- Provide JsonSchema support to jsonls
		-- Redundant for yamlls but still used for advanced optional features
		"b0o/schemastore.nvim",
	},
	{
		"cenk1cenk2/schema-companion.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
		},
		config = function()
			require("schema-companion").setup({
				schemas = {},
				enable_telescope = false,
				sources = {
					require("schema-companion").sources.lsp.setup()
				},
				matchers = {
					require("schema-companion").sources.matchers.kubernetes.setup({ version = "master" }),
				},
			})
		end,
	},
}
