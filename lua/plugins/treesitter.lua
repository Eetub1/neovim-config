return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install({
        "lua", "vim", "vimdoc", "bash", "markdown",
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "lua", "vim", "bash", "markdown" },
        callback = function()
          vim.treesitter.start()
        end,
      })
    end,
  },
}
