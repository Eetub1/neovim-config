-- ~/.config/nvim/lua/plugins/lsp.lua
return {
  -- Completion engine
  {
    "saghen/blink.cmp",
    version = "*",
    event = "InsertEnter",
    opts = {
      keymap = { preset = "default" },   -- Ctrl-y accept, Ctrl-n/p cycle
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
    },
  },

  -- Mason: installs the language server binaries
  {
    "mason-org/mason.nvim",
    config = function()
      require("mason").setup()
      -- Make sure mason's binaries are findable when Neovim spawns them
      vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH
    end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "pyright" },
        automatic_enable = true,   -- enables installed servers for you
      })

      vim.lsp.config("*", { capabilities = capabilities })

      vim.lsp.config("lua_ls", {
        settings = { Lua = { diagnostics = { globals = { "vim" } } } },
      })

      vim.lsp.config("pyright", {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",       -- "off" | "basic" | "strict"
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local map = vim.keymap.set
          local o = { buffer = ev.buf }
          map("n", "gd", vim.lsp.buf.definition,  o)
          map("n", "K",  vim.lsp.buf.hover,       o)
          map("n", "gr", vim.lsp.buf.references,  o)
          map("n", "<leader>rn", vim.lsp.buf.rename,       o)
          map("n", "<leader>ca", vim.lsp.buf.code_action,  o)
          map("n", "<leader>d",  vim.diagnostic.open_float, o)
        end,
      })
    end,
  },
}
