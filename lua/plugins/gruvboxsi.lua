return {
  "tkachenkosi/gruvboxsi.nvim",
  priority = 1000 ,
  config = function()
    require("gruvboxsi").setup({
      contrast = "hard",
    })
    require("gruvboxsi").load()
  end
}
