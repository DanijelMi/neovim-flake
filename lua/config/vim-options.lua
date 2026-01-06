-- GENERAL OPTIONS
vim.opt.mouse = "a"                               -- Mouse support in all modes
-- vim.cmd [[autocmd BufEnter * silent! lcd %:p:h]]
vim.opt.backspace = { "indent", "eol", "nostop" } -- What can be backspaced after entering insert mode
vim.opt.wildmenu = true                           -- Display command line's tab complete options as a menu
vim.opt.wildmode = "longest:full,full"            -- Completion mode for wildmenu
vim.opt.autoread = true                           -- Automatically reload file if it was changed outside of vim
vim.opt.confirm = true                            -- Prompt closing an unsaved file
vim.opt.history = 10000                           -- Stored history of : commands and / searches
vim.opt.undolevels = 1000                         -- Stored history of changes that can be undone
vim.opt.complete = ".,w,b,u,t"                    -- What files/buffers to scan for auto-complete

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- SEARCH OPTIONS
vim.opt.ignorecase = true -- Case insensitive / searches
vim.opt.smartcase = true  -- Disable ignorecase if uppercase letters are found in / search
vim.opt.hlsearch = true   -- Highlight searches
vim.opt.incsearch = true  -- Highlight searches during typing as well

vim.opt.showmode = false  -- Don't show the mode, since it's already in the status line

-- Sync clipboard between OS and Neovim
-- Schedule the setting after `UiEnter` to optimize startup-time.
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

-- VISUAL OPTIONS
vim.opt.laststatus = 2 -- Always show status line
vim.opt.background = "dark" -- Dark or light mode
vim.opt.ruler = true -- Show line and col numbers in status
vim.opt.list = true -- Display whitespace characters (tabs, trailing spaces, etc.)
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' } -- Configure which whitespace characters to display

-- TAB AND SHIFT OPTIONS
vim.opt.shiftround = true -- Round indent to multiple of shiftwidth
vim.opt.shiftwidth = 2    -- How many spaces represent an indent
vim.opt.tabstop = 2       -- Display width of a tab character

-- LINE DISPLAY
vim.opt.number = true         -- Print the line number in front of each line
vim.opt.wrap = true           -- Soft wrapping
vim.opt.smoothscroll = true   -- Don't skip over wrapped lines when scrolling
vim.opt.breakindent = true    -- Every wrapped line inherits indent
vim.opt.signcolumn = "auto:2" -- Keep signcolumn on by default
vim.opt.cursorline = true     -- Show which line your cursor is on
vim.opt.scrolloff = 5         -- Minimal number of screen lines to keep above and below the cursor.

-- DIRECTORY-RELATED OPTIONS
vim.opt.updatetime = 1000 -- Time in idle ms before auto-saving swap file to disk
vim.opt.undofile = true

vim.opt.timeoutlen = 500     -- Decrease mapped sequence wait time, displays which-key popup sooner
vim.opt.splitright = true    -- When v-splitting window, move focus to right
vim.opt.splitbelow = true    -- When h-splitting window, move focus below

vim.opt.inccommand = "split" -- Preview substitutions live, in a temporary split window

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- NAVIGATION
-- No arrows
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- GENERAL AUTOCOMMANDS
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- CUSTOM BINDS
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })
-- Sudo write for non root files
vim.keymap.set("c", "w!!", "w !sudo tee % > /dev/null", { noremap = true, silent = true, desc = "Sudo write file" })

-- Yank current line, comment it, then paste below
vim.keymap.set('n', 'gy', function()
	vim.cmd('t.')
	vim.cmd('normal! k')
	vim.cmd('normal gcc')
	vim.cmd('normal! j')
end, { noremap = true, silent = true, desc = "Comment & duplicate line" })

-- Close entire neovim tab
vim.keymap.set("n", "<C-w>Q", ":tabclose<CR>", { desc = "Close current tab" })

-- Calculate simple math, visual only
vim.api.nvim_set_keymap("v", "g=", [[c<C-r>=<C-r>"<CR><Esc>]],
	{ noremap = true, silent = true, desc = "Calculate visual selection" }
)

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" }) -- Diagnostic keymaps TODO
