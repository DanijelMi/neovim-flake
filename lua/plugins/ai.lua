return {
	{
		"NickvanDyke/opencode.nvim",
		dependencies = {
			-- Recommended for `ask()` and `select()`.
			-- Required for `snacks` provider.
			---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
			{ "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
		},
		config = function()
		---@type opencode.Opts
		vim.g.opencode_opts = {
			-- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition".
		}

			-- Required for `opts.events.reload`.
			vim.o.autoread = true

			-- Core keymaps
			vim.keymap.set({ "n", "x" }, "<leader>ca", function() require("opencode").ask("@this: ", { submit = true }) end,
				{ desc = "Ask opencode" })
			vim.keymap.set({ "n" }, "<leader>cA", function() require("opencode").ask() end,
				{ desc = "Ask opencode (empty)" })
			vim.keymap.set({ "n", "x" }, "<leader>cx", function() require("opencode").select() end,
				{ desc = "Execute opencode action" })
			vim.keymap.set({ "n", "t" }, "<leader>cc", function() require("opencode").toggle() end,
				{ desc = "Toggle opencode" })

			-- Operator keymaps
			vim.keymap.set({ "n", "x" }, "<leader>co", function() return require("opencode").operator("@this ") end,
				{ expr = true, desc = "Add range to opencode" })
			vim.keymap.set("n", "<leader>coo", function() return require("opencode").operator("@this ") .. "_" end,
				{ expr = true, desc = "Add line to opencode" })

			-- Session management
			vim.keymap.set("n", "<leader>cn", function() require("opencode").command("session.new") end,
				{ desc = "New session" })
			vim.keymap.set("n", "<leader>cl", function() require("opencode").command("session.list") end,
				{ desc = "List sessions" })
			vim.keymap.set("n", "<leader>cs", function() require("opencode").command("session.share") end,
				{ desc = "Share session" })
			vim.keymap.set("n", "<leader>ci", function() require("opencode").command("session.interrupt") end,
				{ desc = "Interrupt session" })
			vim.keymap.set("n", "<leader>cC", function() require("opencode").command("session.compact") end,
				{ desc = "Compact session" })

			-- Message navigation
			vim.keymap.set("n", "<leader>cu", function() require("opencode").command("session.half.page.up") end,
				{ desc = "Scroll messages up (half)" })
			vim.keymap.set("n", "<leader>cd", function() require("opencode").command("session.half.page.down") end,
				{ desc = "Scroll messages down (half)" })
			vim.keymap.set("n", "<leader>cU", function() require("opencode").command("session.page.up") end,
				{ desc = "Scroll messages up (full)" })
			vim.keymap.set("n", "<leader>cD", function() require("opencode").command("session.page.down") end,
				{ desc = "Scroll messages down (full)" })
			vim.keymap.set("n", "<leader>cg", function() require("opencode").command("session.first") end,
				{ desc = "First message" })
			vim.keymap.set("n", "<leader>cG", function() require("opencode").command("session.last") end,
				{ desc = "Last message" })

			-- Undo/Redo
			vim.keymap.set("n", "<leader>cz", function() require("opencode").command("session.undo") end,
				{ desc = "Undo last change" })
			vim.keymap.set("n", "<leader>cZ", function() require("opencode").command("session.redo") end,
				{ desc = "Redo last change" })

			-- Prompt commands
			vim.keymap.set("n", "<leader>cp", function() require("opencode").command("prompt.submit") end,
				{ desc = "Submit prompt" })
			vim.keymap.set("n", "<leader>cP", function() require("opencode").command("prompt.clear") end,
				{ desc = "Clear prompt" })

			-- Agent
			vim.keymap.set("n", "<leader>cw", function() require("opencode").command("agent.cycle") end,
				{ desc = "Cycle agent" })

			-- Quick prompts
			vim.keymap.set({ "n", "x" }, "<leader>cr", function() require("opencode").prompt("review") end,
				{ desc = "Review code" })
			vim.keymap.set({ "n", "x" }, "<leader>cf", function() require("opencode").prompt("fix") end,
				{ desc = "Fix diagnostics" })
			vim.keymap.set({ "n", "x" }, "<leader>ck", function() require("opencode").prompt("explain") end,
				{ desc = "Explain code" })
			vim.keymap.set({ "n", "x" }, "<leader>cv", function() require("opencode").prompt("optimize") end,
				{ desc = "Optimize code" })
			vim.keymap.set({ "n", "x" }, "<leader>cb", function() require("opencode").prompt("document") end,
				{ desc = "Document code" })
			vim.keymap.set({ "n", "x" }, "<leader>cT", function() require("opencode").prompt("test") end,
				{ desc = "Add tests" })
			vim.keymap.set({ "n", "x" }, "<leader>cm", function() require("opencode").prompt("implement") end,
				{ desc = "Implement" })
			vim.keymap.set("n", "<leader>cF", function() require("opencode").prompt("diagnostics") end,
				{ desc = "Explain diagnostics" })
			vim.keymap.set("n", "<leader>cR", function() require("opencode").prompt("diff") end,
				{ desc = "Review diff" })
		end,
	}
}
