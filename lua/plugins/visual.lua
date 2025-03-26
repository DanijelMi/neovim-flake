return {
  { "folke/tokyonight.nvim" }, -- Colorscheme
  {
    "catppuccin/nvim",        -- Colorscheme
    name = "catppuccin",
    priority = 1000,          -- Make sure to load this before all the other start plugins.
    config = function()
      require("catppuccin").setup({
        transparent_background = true,
      })
      vim.cmd.colorscheme("catppuccin")
      -- You can configure highlights by doing something like:
      vim.cmd.hi("Comment gui=bold")
    end,
  },
  {
    "echasnovski/mini.pairs", -- Autopair brackets
    version = false,
    config = function()
      require("mini.pairs").setup()
    end,
  },
  {
    "echasnovski/mini.hipatterns", -- Highlight certain keywords and color codes
    version = false,
    config = function()
      local hipatterns = require("mini.hipatterns")
      hipatterns.setup({
        -- Table with highlighters (see |MiniHipatterns.config| for more details).
        -- Nothing is defined by default. Add manually for visible effect.
        highlighters = {
          -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
          fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
          hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
          todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
          note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
          -- Highlight hex color strings (`#rrggbb`) using that color
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
        -- Delays (in ms) defining asynchronous highlighting process
        delay = {
          -- How much to wait for update after every text change
          text_change = 200,
          -- How much to wait for update after window scroll
          scroll = 50,
        },
      })
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim", -- Visual guidelines for identation levels
    main = "ibl",
    config = function()
      require("ibl").setup()
      vim.opt.list = true
      vim.opt.listchars = { space = "·", tab = "→ " }
    end,
  },
  {
    "folke/styler.nvim", -- Colorscheme per filetype
    config = function()
      require("styler").setup({
        themes = {
          markdown = { colorscheme = "torte" },
          help = { colorscheme = "tokyonight", background = "dark" },
          terraform = { colorscheme = "catppuccin-mocha", background = "dark" }, -- TODO: find a purple colorscheme here
          terminal = { colorscheme = "tokyonight-night", background = "dark", transparent_background = false },
        },
        -- Usually terminal buffers have no filetype set, so we set it up for Styler to work
        vim.api.nvim_create_autocmd({ "TermOpen" }, {
          pattern = "*",
          callback = function()
            vim.bo.filetype = "terminal"
          end,
        }),
      })
    end,
  },
  {
    "sphamba/smear-cursor.nvim",
    opts = {
      stiffness = 0.8,
      trailing_stiffness = 0.4,
      distance_stop_animating = 0.1, -- 0.1      > 0
    },
  },
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
}
