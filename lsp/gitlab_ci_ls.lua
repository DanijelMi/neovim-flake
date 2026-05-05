-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/gitlab_ci_ls.lua
local cache_dir = vim.uv.os_homedir() .. '/.cache/gitlab-ci-ls/'

---@type vim.lsp.Config
return {
	cmd = { 'gitlab-ci-ls' },
	filetypes = { 'yaml.gitlab' },
	-- Use a function to support glob matching on .gitlab* (root_markers only accepts exact names)
	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		on_dir(vim.fs.root(fname, { '.git', '.gitlab-ci.yml', '.gitlab' }))
	end,
	init_options = {
		cache_path = cache_dir,
		log_path = cache_dir .. 'log/gitlab-ci-ls.log',
	},
}
