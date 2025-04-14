-- Calls dedicated formatter tools if they exist, otherwise resort to LSP formatting if exists
return {
	-- 			sources = {
	-- 				-- null_ls.builtins.diagnostics.shellcheck,
	-- 			},
	{
		"stevearc/conform.nvim",
		lazy = false,
		keys = {
			{
				"<leader>gf",
				function()
					-- vim.lsp.buf.format asks LSP for formatting capabilities, we don't want to ask LSP first.
					-- We want a wrapper in front from Conform that can resort to vim.lsp.buf.format() as fallback
					require("conform").format({ lsp_format = "fallback" })
				end,
				desc = "Conform: Format code",
			},
		},
		-- config = function(_, opts)
		config = function()
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" -- register for gq movement
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					nix = { "nixfmt" },
					terraform = { "terraform_fmt" },
					markdown = { "prettier" },
					bash = { "shfmt", "shellharden" },
				},
				default_format_opts = {
					lsp_format = "fallback",
				},
				-- If this is set, Conform will run the formatter on (before)save.
				format_on_save = {
					-- These options will be passed to conform.format()
					timeout_ms = 500,
				},
			})
		end,
	},
}
