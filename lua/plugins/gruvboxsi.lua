return {
  "tkachenkosi/gruvboxsi.nvim",
  priority = 1000 ,
  config = function()
    require("gruvboxsi").setup({
      contrast = "hard",
			palette_overrides = {
				-- dark3 = "#1d3c5a",
				-- dark3 = "#224466",
			},
    })
    require("gruvboxsi").load()
  end
}
