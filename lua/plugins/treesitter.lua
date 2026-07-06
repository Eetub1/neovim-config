-- ~/.config/nvim/lua/plugins/treesitter.lua
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",       -- the rewrite (default branch now)
    lazy = false,
    build = ":TSUpdate",
    config = function()
      -- Install the parsers you want (downloads & compiles them)
      require("nvim-treesitter").install({
        "lua", "vim", "vimdoc", "bash", "markdown",
      })

      -- Highlighting is no longer automatic — enable it per filetype yourself
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "lua", "vim", "bash", "markdown" },
        callback = function()
          vim.treesitter.start()
        end,
      })
    end,
  },
}
