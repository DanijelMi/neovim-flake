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

			-- Lua
			lspconfig["lua_ls"].setup({
				capabilities = capabilities,
				settings = { Lua = { runtime = { version = "LuaJIT" }, hint = { enable = true } } },
			})
			-- Nix
			lspconfig["nixd"].setup({ capabilities = capabilities })
			-- Markdown
			lspconfig["marksman"].setup({ capabilities = capabilities })
			-- Terraform
			lspconfig["terraformls"].setup({ capabilities = capabilities })
			lspconfig["tflint"].setup({ capabilities = capabilities })
			-- Bash
			lspconfig["bashls"].setup({ capabilities = capabilities })
			-- Grammar
			lspconfig["harper_ls"].setup({
				capabilities = capabilities,
				filetypes = { "markdown", "text" },
			})
			-- JSON
			lspconfig["jsonls"].setup({
				capabilities = capabilities,
				schemas = require("schemastore").json.schemas(),
				validate = { enable = true },
			})
			-- YAML
			lspconfig.yamlls.setup({
				require("schema-companion").setup_client({ -- Wrap
					capabilities = capabilities,
					settings = {
						yaml = {
							schemaStore = {
								-- Disable built-in schemaStore fetching, we aree reliyng on schemastore plugin
								enable = false,
								-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
								url = "",
							},
							schemas = require("schemastore").yaml.schemas(),
						},
					},
				}),
			})
			-- Gitlab (depends on yamlls + gitlab schema)
			lspconfig["gitlab_ci_ls"].setup({ capabilities = capabilities })
			-- PostgreSQL
			lspconfig["postgres_lsp"].setup({ capabilities = capabilities })

			-- vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, { desc = "LSP: Show diagnostic" })
			-- vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, { desc = "LSP: setloclist" })
			-- vim.keymap.set("n", "<space>k", vim.lsp.buf.hover, { desc = "LSP: hover" })
	{
		-- Provide JsonSchema support to jsonls
		-- Redundant for yamlls but still used for advanced optional features
		"b0o/schemastore.nvim",
	},
		end,
	},
}
