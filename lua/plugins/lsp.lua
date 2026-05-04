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
			integrations = {
				-- Disable lspconfig integration — we use native vim.lsp.config (nvim 0.12+)
				lspconfig = false,
			},
		},
	},
	{
		-- Provides lsp/*.lua base configs for 300+ servers (passive — no setup() needed)
		"neovim/nvim-lspconfig",
		lazy = false,
	},
	{
		-- LSP setup — uses native vim.lsp.config/enable API (nvim 0.12+)
		-- Base server configs come from nvim-lspconfig; overrides live in after/lsp/*.lua
		"saghen/blink.cmp", -- dependency anchor; ensures blink is loaded before capabilities are set
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

			-- LSP servers and clients communicate what features they support.
			-- blink.cmp extends Neovim's default capabilities, so we broadcast that to all servers.
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			vim.lsp.config('*', { capabilities = capabilities })

			-- Overrides on top of nvim-lspconfig defaults
			vim.lsp.config('harper_ls', { filetypes = { 'markdown', 'text' } })
			vim.lsp.config('jsonls', {
				settings = {
					json = {
						schemas = require('schemastore').json.schemas(),
						validate = { enable = true },
					},
				},
			})
			vim.lsp.config('yamlls', {
				settings = {
					yaml = {
						schemaStore = {
							enable = false,
							-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
							url = '',
						},
						schemas = require('schemastore').yaml.schemas(),
					},
				},
			})

			vim.lsp.enable({
				'lua_ls',
				'nixd',
				'marksman',
				'terraformls',
				'tflint',
				'bashls',
				'basedpyright',
				'harper_ls',
				'jsonls',
				'yamlls',
				'gitlab_ci_ls',
			})

			-- vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, { desc = "LSP: Show diagnostic" })
			-- vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, { desc = "LSP: setloclist" })
			-- vim.keymap.set("n", "<space>k", vim.lsp.buf.hover, { desc = "LSP: hover" })

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					-- Helper to create buffer-local LSP keymaps
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					local client = vim.lsp.get_client_by_id(event.data.client_id)

					-- Highlight references of the word under your cursor when it rests there.
					-- See `:help CursorHold` for when this fires.
					if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
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

					-- Toggle inlay hints if the server supports them
					if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
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
			{ "folke/snacks.nvim" },
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
		-- Provides JSON/YAML schema lists for jsonls and yamlls
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
					require("schema-companion").sources.lsp.setup(),
				},
				matchers = {
					require("schema-companion").sources.matchers.kubernetes.setup({ version = "master" }),
				},
			})
		end,
	},
}
