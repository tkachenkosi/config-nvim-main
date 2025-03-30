return {
  "tkachenkosi/gruvboxsi.nvim",
  priority = 1000 , 
  config = function()
    local grouv = require("gruvboxsi")
    grouv.setup({
      contrast = "hard",
    })
    grouv.load()
  end
}
