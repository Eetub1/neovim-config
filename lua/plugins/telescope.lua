return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })

      telescope.load_extension("fzf")

      local builtin = require("telescope.builtin")
      local map = vim.keymap.set
      map("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
      map("n", "<leader>fg", builtin.live_grep,  { desc = "Live grep (search text)" })
      map("n", "<leader>fb", builtin.buffers,    { desc = "Find open buffers" })
      map("n", "<leader>fh", builtin.help_tags,  { desc = "Search help" })
      map("n", "<leader>fr", builtin.oldfiles,   { desc = "Recent files" })
    end,
  },
}
