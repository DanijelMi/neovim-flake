-- Wraps linting and formatting tools into the LSP protocol
return {
  "nvimtools/none-ls.nvim",
  config = function()
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.nixfmt,
        null_ls.builtins.formatting.terraform_fmt.with({ timeout_ms = 2000 }),
        -- null_ls.builtins.diagnostics.shellcheck,
        null_ls.builtins.formatting.prettier.with({
          filetypes = { "html", "json", "yaml", "markdown" },
        }),
        null_ls.builtins.formatting.shfmt,
        null_ls.builtins.formatting.shellharden,
        -- Python TODO
        -- null_ls.builtins.diagnostics.flake8,
        -- null_ls.builtins.formatting.black.with({ extra_args = { "--fast" }}),
      },
      -- Format on buffer save
      -- you can reuse a shared lspconfig on_attach callback here
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            -- pattern = { "*.tf", "*.tfvars" }, -- Optionally specify which file types to trigger on
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ async = false })
              -- })
            end,
          })
        end
      end,
      vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { desc = "Format Code" }),
    })
  end,
}
