return {
  ------------------------------------
  -- nvim-treesitter (main branch)
  ------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install({
        -- noice.nvim requirements
        "vim",
        "vimdoc",
        "regex",
        "lua",
        "bash",
        "markdown",
        "markdown_inline",
        -- working languages
        "typescript",
        "tsx",
        "javascript",
        "php",
        -- config / data formats
        "json",
        "toml",
        "yaml",
        "html",
        "css",
        -- treesitter query files
        "query",
      })

      local notified_langs = {}

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
        callback = function()
          -- skip special buffers (terminal, help, quickfix, etc.)
          if vim.bo.buftype ~= "" then
            return
          end
          -- skip large files for performance
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(0))
          if ok and stats and stats.size > 100 * 1024 then
            return
          end
          if pcall(vim.treesitter.start) then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          else
            -- suggest :TSInstall when a known parser is missing
            local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
            if lang and not notified_langs[lang] then
              local has_parser = pcall(vim.treesitter.language.inspect, lang)
              if not has_parser then
                notified_langs[lang] = true
                vim.notify(
                  "Treesitter parser not installed: " .. lang .. "\nRun :TSInstall " .. lang,
                  vim.log.levels.WARN
                )
              end
            end
          end
        end,
      })
    end,
  },

  ------------------------------------
  -- nvim-treesitter-textobjects
  ------------------------------------
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      local tso = require("nvim-treesitter-textobjects")
      tso.setup({
        select = {
          lookahead = true,
        },
        move = {
          set_jumps = true,
        },
      })

      -- Select
      local select_to = require("nvim-treesitter-textobjects.select").select_textobject
      local select_maps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["al"] = "@loop.outer",
        ["il"] = "@loop.inner",
      }
      for key, query in pairs(select_maps) do
        vim.keymap.set({ "x", "o" }, key, function()
          select_to(query, "textobjects")
        end, { desc = "TS: " .. query })
      end

      -- Move
      local move = require("nvim-treesitter-textobjects.move")
      local move_maps = {
        ["]m"] = { move.goto_next_start, "@function.outer", "Next function start" },
        ["]M"] = { move.goto_next_end, "@function.outer", "Next function end" },
        ["]]"] = { move.goto_next_start, "@class.outer", "Next class start" },
        ["]["] = { move.goto_next_end, "@class.outer", "Next class end" },
        ["[m"] = { move.goto_previous_start, "@function.outer", "Prev function start" },
        ["[M"] = { move.goto_previous_end, "@function.outer", "Prev function end" },
        ["[["] = { move.goto_previous_start, "@class.outer", "Prev class start" },
        ["[]"] = { move.goto_previous_end, "@class.outer", "Prev class end" },
      }
      for key, spec in pairs(move_maps) do
        vim.keymap.set({ "n", "x", "o" }, key, function()
          spec[1](spec[2], "textobjects")
        end, { desc = spec[3] })
      end

      -- Swap
      local swap = require("nvim-treesitter-textobjects.swap")
      vim.keymap.set("n", "<leader>xa", function()
        swap.swap_next("@parameter.inner")
      end, { desc = "Swap with next parameter" })
      vim.keymap.set("n", "<leader>xA", function()
        swap.swap_previous("@parameter.inner")
      end, { desc = "Swap with prev parameter" })
    end,
  },
}
