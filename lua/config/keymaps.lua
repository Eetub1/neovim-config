local map = vim.keymap.set

map("n", "j", "h", { desc = "Move left" })
map("n", "k", "k", { desc = "Move up" })
map("n", "l", "j", { desc = "Move down" })
map("n", "ö", "l", { desc = "Move right" })

map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

map("n", "<leader>t", function()
  vim.cmd("split | terminal")
  vim.cmd("startinsert")
end, { desc = "Open terminal" })
