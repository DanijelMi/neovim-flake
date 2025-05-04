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
		-- config = function(_, opts)
		config = function()
			-- capabilities.textDocument.foldingRange = {
			--   dynamicRegistration = false,
			--   lineFoldingOnly = true,
			-- }

			-- vim.diagnostic.config({
			--   virtual_text = false,
			--   signs = true,
			--   underline = true,
			--   update_in_insert = true,
			--   severity_sort = false,
			-- })

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
				filetypes = { "markdown", "gitcommit", "text" },
			})
			-- PostgreSQL
			lspconfig["postgres_lsp"].setup({ capabilities = capabilities })

			-- vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, { desc = "LSP: Show diagnostic" })
			-- vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, { desc = "LSP: setloclist" })
			-- vim.keymap.set("n", "<space>k", vim.lsp.buf.hover, { desc = "LSP: hover" })
		end,
	},
}
