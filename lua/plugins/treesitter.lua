return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	opts = {
		ensure_installed = {
			"bash",
			"c",
			"diff",
			"html",
			"lua",
			"luadoc",
			"markdown",
			"markdown_inline",
			"query",
			"vim",
			"vimdoc",
			"nix",
			"hcl",
			"terraform",
		},
		-- Install parsers synchronously (only applied to `ensure_installed`)
		sync_install = false,
		-- Autoinstall languages that are not installed
		auto_install = true,
		highlight = {
			enable = true,
			-- Disable slow treesitter highlight for large files
			disable = function(lang, buf)
				local max_filesize = 100 * 1024 -- 100 KB
				local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
				if ok and stats and stats.size > max_filesize then
					return true
				end
			end,
			additional_vim_regex_highlighting = false,
		},
		-- Indentation based on treesitter for the = operator
		indent = { enable = true, disable = { "ruby" } },
		-- Incremental selection based on the named nodes from the grammar
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "gnn", -- set to `false` to disable one of the mappings
				node_incremental = "grn",
				scope_incremental = "grc",
				node_decremental = "grm",
			},
		},
	},
	config = function(_, opts)
		-- [[ Configure Treesitter ]] See `:help nvim-treesitter`

		---@diagnostic disable-next-line: missing-fields
		require("nvim-treesitter.configs").setup(opts)

		-- There are additional nvim-treesitter modules that you can use to interact
		-- with nvim-treesitter. You should go explore a few and see what interests you:
		-- - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
		-- - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
	end,
}
