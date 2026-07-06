-- ~/.config/nvim/lua/plugins/lsp.lua
return {
  -- Completion engine
  {
    "saghen/blink.cmp",
    version = "*",              -- released version ships a prebuilt binary
    event = "InsertEnter",
    opts = {
      keymap = { preset = "default" },   -- Ctrl-y accept, Ctrl-n/p cycle, Ctrl-space open
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim", config = true },
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls" },   -- add more servers here later
      })

      -- Default capabilities for every server (0.11+ native API)
      vim.lsp.config("*", { capabilities = capabilities })

      -- Lua server, with a tweak so it knows about the `vim` global
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = { diagnostics = { globals = { "vim" } } },
        },
      })
      vim.lsp.enable("lua_ls")

      -- Keymaps that activate once a server attaches to a buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local map = vim.keymap.set
          local o = { buffer = ev.buf }
          map("n", "gd", vim.lsp.buf.definition,  o)  -- go to definition
          map("n", "K",  vim.lsp.buf.hover,       o)  -- hover docs
          map("n", "gr", vim.lsp.buf.references,  o)  -- find references
          map("n", "<leader>rn", vim.lsp.buf.rename,      o)  -- rename symbol
          map("n", "<leader>ca", vim.lsp.buf.code_action, o)  -- code actions
          map("n", "<leader>d",  vim.diagnostic.open_float, o) -- show diagnostic
        end,
      })
    end,
  },
}
