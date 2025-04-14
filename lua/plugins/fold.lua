-- Stripped down config from here https://github.com/kevinhwang91/nvim-ufo/issues/4
-- Also check out https://github.com/luukvbaal/statuscol.nvim
return {
	"kevinhwang91/nvim-ufo",
	dependencies = "kevinhwang91/promise-async",
	event = "VeryLazy",
	opts = {
		-- INFO: Uncomment to use treeitter as fold provider, otherwise nvim lsp is used
		provider_selector = function(bufnr, filetype, buftype)
			return { "treesitter", "indent" }
		end,
		open_fold_hl_timeout = 400,
		close_fold_kinds_for_ft = { "imports", "comment" },
		preview = {
			win_config = {
				border = { "", "─", "", "", "", "─", "", "" },
				winhighlight = "Normal:Folded",
				winblend = 0,
			},
		},
	},
	init = function()
		vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
		vim.o.foldcolumn = "1" -- '0' is not bad
		vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
		vim.o.foldlevelstart = 99
		vim.o.foldenable = true
	end,
	config = function(_, opts)
		require("ufo").setup()
		-- Preview folds
		local function peekOrHover()
			local winid = require("ufo").peekFoldedLinesUnderCursor()
			if winid then
				local bufnr = vim.api.nvim_win_get_buf(winid)
				local keys = { "a", "i", "o", "A", "I", "O", "gd", "gr" }
				for _, k in ipairs(keys) do
					-- Add a prefix key to fire `trace` action,
					-- if Neovim is 0.8.0 before, remap yourself
					vim.keymap.set("n", k, "<CR>" .. k, { noremap = false, buffer = bufnr })
				end
			else
				vim.lsp.buf.hover() -- fallback default functionality on K
			end
		end
		vim.keymap.set("n", "K", peekOrHover, { noremap = true, silent = true })
	end,
}
