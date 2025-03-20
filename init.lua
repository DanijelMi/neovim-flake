-- LazyVim bootstrap --
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("vim-options")           -- Import vim options
require("lazy").setup("plugins") -- Init lazyvim

-- Custom logic not related to lazy plugins goes here

function terminal_send(execute)
  local first_terminal_chan = get_first_terminal()

  local command_to_paste
  local current_mode = vim.api.nvim_get_mode().mode
  print(current_mode)
  if current_mode == "v" or current_mode == "V" or current_mode == "" then
    command_to_paste = vim.fn.getreg('"')
  else
    command_to_paste = vim.fn.getline(".")
  end

  if execute then
    command_to_paste = command_to_paste .. "\n"
  end
  vim.api.nvim_chan_send(first_terminal_chan, command_to_paste)
end

function get_first_terminal()
  local terminal_chans = {}
  for _, chan in pairs(vim.api.nvim_list_chans()) do
    if chan["mode"] == "terminal" and chan["pty"] ~= "" then
      table.insert(terminal_chans, chan)
    end
  end

  table.sort(terminal_chans, function(left, right)
    return left["buffer"] < right["buffer"]
  end)

  return terminal_chans[1]["id"]
end

vim.api.nvim_set_keymap(
  "n",
  "<leader>ta",
  ":lua terminal_send(false)<CR>",
  { noremap = true, silent = true, desc = "Append selected line to the first terminal buffer" }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>tr",
  ":lua terminal_send(true)<CR>",
  { noremap = true, silent = true, desc = "Append and run selected line to the first terminal buffer" }
)
