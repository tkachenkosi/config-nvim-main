return {
  {
    "nvim-treesitter/nvim-treesitter",
    config = function() 
      require("nvim-treesitter.configs").setup({
        ensure_installed = {"c", "cpp", "lua", "typescript", "javascript", "query", "rust", "go", "css", "html", "json", "make", "sql", "toml", "bash"},
        auto_install = true,
        highlight = {
          enable = true,
        }
      })
    end
  }
}
