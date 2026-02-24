return {
  -- Tool package manager
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    opts = {},
  },

  -- LSP server auto-installer
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        "ts_ls",
        "intelephense",
        "lua_ls",
      },
      automatic_enable = false,
    },
  },

  -- Formatter / linter auto-installer
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        "prettier",
        "php-cs-fixer",
        "stylua",
        "eslint_d",
        "phpstan",
      },
      run_on_start = true,
      start_delay = 3000,
    },
  },

  -- LSP server configurations
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-org/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      local lspconfig = require("lspconfig")

      ---@type table<string, lspconfig.Config>
      local servers = {
        ts_ls = {},
        intelephense = {},
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              workspace = {
                checkThirdParty = false,
                library = { vim.env.VIMRUNTIME },
              },
              completion = { callSnippet = "Replace" },
            },
          },
        },
      }

      for server, config in pairs(servers) do
        config.capabilities = capabilities
        lspconfig[server].setup(config)
      end

      -- Keymaps on LSP attach (complement snacks.nvim pickers)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(args)
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, desc = "LSP: " .. desc })
          end
          map("n", "D", vim.lsp.buf.hover, "Hover Documentation")
          map("n", "gK", vim.lsp.buf.signature_help, "Signature Help")
          map("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
          map({ "n", "v" }, "<leader>ra", vim.lsp.buf.code_action, "Code Action")
          map("n", "gl", vim.diagnostic.open_float, "Line Diagnostics")
        end,
      })

      -- Diagnostic display
      vim.diagnostic.config({
        virtual_text = { spacing = 4, prefix = "●" },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = true,
        },
      })
    end,
  },
}
