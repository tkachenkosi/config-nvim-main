vim.pack.add({
	{
		src = "https://github.com/tkachenkosi/micro-snippets.nvim.git",
		name = "micro-snippets.nvim",
		version = "master",
	},
})

-- :checkhealth vim.pack
require("snippets").setup()
