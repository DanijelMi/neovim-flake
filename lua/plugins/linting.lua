-- LSPs can have linting and formatting as well
-- When configuring capabilities for a tool, check for availability in LSP_Config first.
-- THEN keep looking for formatters if LSP does not provide one
-- Same logic applies for linters too, although there is some value to have multiple linting sources compared to formatters.
--
-- LSPs: :help lspconfig-all
-- Linters: https://github.com/mfussenegger/nvim-lint?tab=readme-ov-file#available-linters
-- Formatters: :help conform-formatters
return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")
		lint.linters_by_ft = {
			markdown = { "markdownlint" },
			-- sh = { "bash", "shellcheck" },
			gitcommit = { "commitlint" },
			env = { "dotenv_linter" },
			terraform = { "trivy" },
			python = { "ruff" },
			-- text = { "vale" },
			-- make = { "checkmake" },
			-- json = { "jsonlint" },
			-- nix = { "nix" },
		}
		-- Create autocommand which carries out the actual linting
		-- on the specified events.
		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				-- Only run the linter in buffers that you can modify in order to
				-- avoid superfluous noise, notably within the handy LSP pop-ups that
				-- describe the hovered symbol using Markdown.
				if vim.opt_local.modifiable:get() then
					lint.try_lint()
				end
			end,
		})

		-- Mimic a "LspInfo"-like command for Linters
		vim.api.nvim_create_user_command("LintInfo", function()
			local filetype = vim.bo.filetype
			local linters = require("lint").linters_by_ft[filetype]

			if linters then
				print("Linters for " .. filetype .. ": " .. table.concat(linters, ", "))
			else
				print("No linters configured for filetype: " .. filetype)
			end
		end, {})
	end,
}
