return {
  "lewis6991/gitsigns.nvim",
  config = function() 
    require("gitsigns").setup({
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      -- signcolumn = true,
      attach_to_untracked = true,
      watch_gitdir = {
        interval = 13000,
        follow_files = true
      },
      update_debounce = 1000,	-- 500
      max_file_length = 9000,
    })
  end
}
