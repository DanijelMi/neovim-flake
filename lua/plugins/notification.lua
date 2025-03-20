return {
  "echasnovski/mini.notify",
  version = false,
  config = function()
    local MiniNotify = require("mini.notify")
    MiniNotify.setup()
    vim.notify = MiniNotify.make_notify() -- Wrap built-in vim.notify into the MiniNotify version
  end,
}
