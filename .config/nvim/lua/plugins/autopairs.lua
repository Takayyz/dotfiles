return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    check_ts = true,
    fast_wrap = {
      map = "<M-e>",
    },
  },
  config = function(_, opts)
    local npairs = require("nvim-autopairs")
    npairs.setup(opts)
    -- Disable backtick auto-pairing in markdown
    local Rule = require("nvim-autopairs.rule")
    npairs.remove_rule("`")
    npairs.add_rule(Rule("`", "`"):with_pair(function()
      return vim.bo.filetype ~= "markdown"
    end))
  end,
}
