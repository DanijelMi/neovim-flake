return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim",           -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    config = function()
      local neotree = require("neo-tree")
      neotree.setup({
        close_if_last_window = true,
        filesystem = {
          hijack_netrw_behavior = "disabled",
          follow_current_file = {
            enabled = true,
          },
        },
      })
    end,
    lazy = false,
    keys = {
      { "<leader>n", "<CMD>Neotree filesystem toggle<CR>", mode = "n", desc = "Toggle Neotree view" },
    },
  },
  -- {
  --   "stevearc/oil.nvim",
  --   opts = {},
  --   dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
  --   config = function()
  --     require("oil").setup()
  --   end,
  --   keys = {
  --    { "-", "<CMD>Oil<CR>", mode = "n", desc = "Open Oil.nvim file browser" },
  --   },
  -- },
  {
    "echasnovski/mini.files",
    version = false,
    lazy = false,
    config = function()
      local filter_show = function(_)
        return true
      end
      local filter_hide = function(fs_entry)
        return not vim.startswith(fs_entry.name, ".")
      end
      local MiniFiles = require("mini.files")
      MiniFiles.setup({
        mappings = {
          close = "q",
          go_in = "l",
          go_in_plus = "L",
          go_out = "h",
          go_out_plus = "H",
          reset = "<BS>",
          reveal_cwd = "@",
          show_help = "g?",
          synchronize = "=",
          trim_left = "<",
          trim_right = ">",
        },
        content = {
          filter = filter_hide,
        },
      })

      -- Mapping to toggle dot-files
      local show_dotfiles = false
      local toggle_dotfiles = function()
        show_dotfiles = not show_dotfiles
        local new_filter = show_dotfiles and filter_show or filter_hide
        MiniFiles.refresh({ content = { filter = new_filter } })
      end

      -- Open file with external program
      local external_open = function()
        local fs_entry = MiniFiles.get_fs_entry()
        if fs_entry == nil then
          vim.notify("No fs_entry specified", vim.log.levels.ERROR)
          return
        end
        MiniNotify.make_notify()
        vim.notify(vim.inspect(fs_entry))
        vim.fn.system(string.format("xdg-open '%s' &", fs_entry.path))
      end

      local files_set_cwd = function()
        -- Works only if cursor is on the valid file system entry
        local cur_entry_path = MiniFiles.get_fs_entry().path
        local cur_directory = vim.fs.dirname(cur_entry_path)
        -- vim.fn.chdir(cur_directory)
        vim.cmd("tcd " .. vim.fn.fnameescape(cur_directory))
        vim.notify(string.format("'%s' set as CWD (tab-local)", cur_directory))
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = args.data.buf_id, desc = "Toggle dotfiles" })
          vim.keymap.set(
            "n",
            "gx",
            external_open,
            { buffer = args.data.buf_id, desc = "Open file with external program" }
          )
          vim.keymap.set(
            "n",
            "g~",
            files_set_cwd,
            { buffer = args.data.buf_id, desc = "Set CWD to selection (tab-local)" }
          )
        end,
      })
    end,
    keys = {
      {
        "-",
        function()
          require("mini.files").open(vim.api.nvim_buf_get_name(0))
        end,
        mode = "n",
        desc = "Open mini.files from current buffer",
      },
      {
        "<C-->",
        function()
          require("mini.files").open(vim.fn.getcwd())
        end,
        mode = "n",
        desc = "Open mini.files from CWD",
      },
    },
  },
}
