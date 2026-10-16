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
        ensure_installed = {
          "lua_ls",
          "pyright",
          "ts_ls",
          "html",
          "cssls",
          "emmet_ls",
          "clangd",     -- C and C++
        },
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

      -- TypeScript / JavaScript (same inlay hints for both)
      local ts_hints = {
        inlayHints = {
          includeInlayParameterNameHints = "literal",
          includeInlayFunctionReturnTypeHints = true,
        },
      }
      vim.lsp.config("ts_ls", {
        settings = {
          typescript = ts_hints,
          javascript = ts_hints,
        },
      })

      -- HTML
      vim.lsp.config("html", {
        filetypes = { "html", "templ" },
      })

      -- CSS (and friends)
      vim.lsp.config("cssls", {})

      -- Emmet: expand abbreviations in markup files
      vim.lsp.config("emmet_ls", {
        filetypes = { "html", "css", "scss", "less", "javascriptreact", "typescriptreact" },
      })

      -- C / C++ (clangd, told to use gcc's headers and settings)
      vim.lsp.config("clangd", {
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--query-driver=/usr/bin/gcc*,/usr/bin/g++*,/usr/bin/cc,/usr/bin/c++",
        },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local map = vim.keymap.set
          local o = { buffer = ev.buf }

          -- Built-in since Neovim 0.11, no need to map:
          --   grr = references   grn = rename   gra = code action
          --   gri = implementation   K = hover
          map("n", "gd", vim.lsp.buf.definition,  o)
          map("n", "K",  vim.lsp.buf.hover,       o)
          map("n", "<leader>rn", vim.lsp.buf.rename,       o)
          map("n", "<leader>ca", vim.lsp.buf.code_action,  o)
          map("n", "<leader>d",  vim.diagnostic.open_float, o)

          -- Inlay hints: on by default where the server supports them
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client and client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
            map("n", "<leader>ih", function()
              vim.lsp.inlay_hint.enable(
                not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }),
                { bufnr = ev.buf }
              )
            end, vim.tbl_extend("force", o, { desc = "Toggle inlay hints" }))
          end
        end,
      })
    end,
  },
}