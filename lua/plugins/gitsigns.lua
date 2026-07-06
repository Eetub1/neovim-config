return {
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    config = function()
      require("gitsigns").setup()
      local gs = require("gitsigns")
      local map = vim.keymap.set
      map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview git hunk" })
      map("n", "<leader>gs", gs.stage_hunk,   { desc = "Stage git hunk" })
      map("n", "<leader>gr", gs.reset_hunk,   { desc = "Reset git hunk" })
      map("n", "<leader>gb", gs.blame_line,   { desc = "Blame line" })
    end,
  },
}
