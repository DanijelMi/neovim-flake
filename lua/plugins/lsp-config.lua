return {
	{
		-- Configures Lua LSP for your Neovim config, runtime and plugins
		-- used for completion, annotations and signatures of Neovim apis
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	{ "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
	{
		-- Quickstart configs for Nvim LSP
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- nvim-cmp source for neovim's built-in language server client.
		},
		keys = {
			{
				"<leader>lr",
				vim.lsp.buf.rename,
				desc = "LSP Rename",
			},
			{
				"<leader>lc",
				vim.lsp.buf.code_action,
				desc = "LSP Code Action",
			},
			{
				"<leader>ld",
				vim.lsp.buf.declaration,
				desc = "LSP Goto Declaration",
			},
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					-- Create a function that lets us more easily define mappings specific
					-- for LSP related items. It sets the mode, buffer and description for us each time.
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- The following two autocommands are used to highlight references of the
					-- word under your cursor when your cursor rests there for a little while.
					--    See `:help CursorHold` for information about when this is executed
					--
					-- When you move your cursor, the highlights will be cleared (the second autocommand).
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
						local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
							end,
						})
					end
				end,
			})

			-- LSP servers and clients are able to communicate to each other what features they support.
			--  By default, Neovim doesn't support everything that is in the LSP specification.
			--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
			--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

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

			-- Lua LSP
			lspconfig.lua_ls.setup({
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						telemetry = { enable = false },
						completion = {
							callSnippet = "Replace",
						},
					},
				},
				capabilities = capabilities,
			})

			-- Nix LSP
			lspconfig.nixd.setup({
				-- on_attach = on_attach(),
				capabilities = capabilities,
			})

			-- Markdown LSP
			lspconfig.marksman.setup({
				settings = {
					single_file_support = false,
				},
				capabilities = capabilities,
			})

			-- Terraform LSP
			lspconfig.terraformls.setup({
				capabilities = capabilities,
			})
			lspconfig.tflint.setup({
				capabilities = capabilities,
			})

			-- vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, { desc = "LSP: Show diagnostic" })
			-- vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "LSP: goto prev" })
			-- vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "LSP: goto next" })
			-- vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, { desc = "LSP: setloclist" })
			-- vim.keymap.set("n", "<space>k", vim.lsp.buf.hover, { desc = "LSP: hover" })
			-- vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP: Code Action" })
			-- vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { desc = "LSP: Rename" })
		end,
	},
}
