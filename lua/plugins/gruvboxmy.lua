return {
  "tkachenkosi/gruvboxmy.nvim", 
  -- priority = 1000 , 
  config = function()
    local grouv = require("gruvboxmy")
    grouv.setup({
      contrast = "hard",
    })
    grouv.load()
  end
}
