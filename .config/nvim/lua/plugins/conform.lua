return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = "ConformInfo",
  keys = {
    {
      "<leader>F",
      function()
        require("conform").format({ async = true, lsp_format = "fallback" })
      end,
      mode = "",
      desc = "Format Buffer",
    },
  },

  ---@module "conform"
  ---@type conform.setupOpts
  opts = {
    formatters_by_ft = {
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      json = { "prettier" },
      html = { "prettier" },
      css = { "prettier" },
      markdown = { "prettier" },
      -- プロジェクトの .nvim.lua で vim.g.disable_php_cs_fixer = true にすると無効化
      -- lsp_format = "never" で LSP へのフォールバック整形も止める
      php = function()
        if vim.g.disable_php_cs_fixer then
          return { lsp_format = "never" }
        end
        return { "php_cs_fixer" }
      end,
      lua = { "stylua" },
    },
    default_format_opts = {
      lsp_format = "fallback",
    },
    format_on_save = {
      timeout_ms = 1000,
      lsp_format = "fallback",
    },
  },
}
