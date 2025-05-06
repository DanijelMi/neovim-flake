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
			-- PostgreSQL
			lspconfig["postgres_lsp"].setup({ capabilities = capabilities })

			-- vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, { desc = "LSP: Show diagnostic" })
			-- vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, { desc = "LSP: setloclist" })
			-- vim.keymap.set("n", "<space>k", vim.lsp.buf.hover, { desc = "LSP: hover" })
		end,
	},
}
