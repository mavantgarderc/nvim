local keymap = vim.keymap.set

keymap('n', '<space>rs', '<cmd>IronRepl<cr>', { desc = "Start Iron REPL" })
keymap('n', '<space>rr', '<cmd>IronRestart<cr>', { desc = "Restart Iron REPL" })
keymap('n', '<space>rf', '<cmd>IronFocus<cr>', { desc = "Focus Iron REPL" })
keymap('n', '<space>rh', '<cmd>IronHide<cr>', { desc = "Hide Iron REPL" })
