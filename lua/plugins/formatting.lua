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
				"grf",
				function()
					-- vim.lsp.buf.format() asks LSP for formatting capabilities, we don't want to ask LSP first.
					-- We want a wrapper in front from Conform that can resort to vim.lsp.buf.format() as fallback
					require("conform").format({ async = true }, function(err, did_edit)
						if did_edit then
							vim.notify("Code formatted successfully.")
						elseif not err then
							vim.notify("No changes made during code format.")
						elseif err then
							vim.notify("Running code format: " .. err)
						end
					end)
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
