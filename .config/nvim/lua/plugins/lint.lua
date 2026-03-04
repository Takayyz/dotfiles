return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      typescript = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      javascript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      php = { "phpstan" },
    }

    --- Find the nearest ancestor directory containing `target` file.
    --- @param bufpath string Absolute path of the current buffer
    --- @param target string Filename to search for (e.g. "composer.json")
    --- @return string|nil
    local function find_project_root(bufpath, target)
      local dir = vim.fn.fnamemodify(bufpath, ":h")
      while dir and dir ~= "/" do
        if vim.uv.fs_stat(dir .. "/" .. target) then
          return dir
        end
        dir = vim.fn.fnamemodify(dir, ":h")
      end
    end

    -- Override phpstan to prefer project-local binary over Mason's global one
    local original_phpstan = lint.linters.phpstan
    lint.linters.phpstan = function()
      local base = type(original_phpstan) == "function" and original_phpstan() or vim.deepcopy(original_phpstan)
      local root = find_project_root(vim.api.nvim_buf_get_name(0), "composer.json")
      if root then
        local local_bin = root .. "/vendor/bin/phpstan"
        if vim.uv.fs_stat(local_bin) then
          base.cmd = local_bin
        end
      end
      return base
    end

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
      callback = function()
        if vim.bo.buftype ~= "" then
          return
        end

        local opts = {}
        if vim.bo.filetype == "php" then
          local root = find_project_root(vim.api.nvim_buf_get_name(0), "composer.json")
          if root then
            opts.cwd = root
          end
        end

        lint.try_lint(nil, opts)
      end,
    })
  end,
}
