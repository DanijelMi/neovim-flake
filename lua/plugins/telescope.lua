return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>/",  "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "[S]earch Current Buffer" },
      { "<leader>sb", "<cmd>Telescope buffers<cr>",                   desc = "[S]earch [B]uffers" },
      { "<leader>sc", "<cmd>Telescope git_commits<cr>",               desc = "[S]earch [C]ommits" },
      { "<leader>sf", "<cmd>Telescope find_files<cr>",                desc = "[S]earch [F]iles" },
      { "<leader>sG", "<cmd>Telescope git_files<cr>",                 desc = "[S]earch [G]it files" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>",                 desc = "[S]earch [H]elp" },
      { "<leader>sk", "<cmd>Telescope keymaps<cr>",                   desc = "[S]earch [K]eymaps" },
      { "<leader>sl", "<cmd>Telescope lsp_references<cr>",            desc = "[S]earch [L]sp References" },
      {
        "<leader>s.",
        "<cmd>Telescope oldfiles<cr>",
        desc = "[S]earch Recent Files [.] for repeat",
      },
      { "<leader>sg", "<cmd>Telescope live_grep<cr>",   desc = "[S]earch by [G]rep" },
      { "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "[S]earch current [W]ord" },
      { "<leader>st", "<cmd>Telescope treesitter<cr>",  desc = "[S]earch Treesitter" },
      { "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "[S]earch [D]iagnostics" },
      {
        "<leader>sn",
        function()
          require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
        end,
        desc = "[S]earch [N]eovim files",
      },
      {
        "<leader>sr",
        function()
          require("telescope.builtin").find_files({
            find_command = {
              "fd",
              "--hidden",
              "--type",
              "d",
              ".git",
              "-X",
              "bash",
              "-c",
              'for dir; do dirname "$dir"; done',
            },
          })
        end,
        desc = "[S]earch Git [R]epos",
      },
    },
    config = function()
      local telescope = require("telescope")
      -- fd --hidden --type d .git -X bash -c 'for dir; do dirname "$dir"; done' -- {}
      telescope.setup({
        pickers = {
          live_grep = {
            file_ignore_patterns = { "node_modules", ".git", ".venv" },
            additional_args = function(_)
              return { "--hidden" }
            end,
          },
          find_files = {
            find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
            file_ignore_patterns = { "node_modules", ".git", ".venv" },
            hidden = true,
          },
        },
      })
      -- local builtin = require("telescope.builtin")
      --
    end,
  },
  -- {
  -- "nvim-telescope/telescope-ui-select.nvim",
  -- config = function()
  --  require("telescope").setup({
  --    defaults = {
  --      layout_config = {
  --        prompt_position = "top",
  --      },
  --      sorting_strategy = "ascending",
  --    },
  --    pickers = {
  --      find_files = {
  --        hidden = true,
  --      },
  --      live_grep = {
  --        additional_args = function()
  --          return { "--hidden", "--glob", "!**/.git/*" }
  --        end,
  --      },
  --      grep_string = {
  --        additional_args = function()
  --          return { "--hidden", "--glob", "!**/.git/*" }
  --        end,
  --      },
  --    },
  --  })
  -- end,
  -- },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
      },
      settings = {
        save_on_toggle = true,
      },
    },
    keys = function()
      local keys = {
        {
          "<leader>H",
          function()
            require("harpoon"):list():add()
          end,
          desc = "Harpoon File",
        },
        {
          "<leader>h",
          function()
            local harpoon = require("harpoon")
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          desc = "Harpoon Quick Menu",
        },
      }
      -- Create 5 binds for jumping to files
      for i = 1, 5 do
        table.insert(keys, {
          "<leader>" .. i,
          function()
            require("harpoon"):list():select(i)
          end,
          desc = "Harpoon to File " .. i,
        })
      end
      return keys
    end,
  },
}
