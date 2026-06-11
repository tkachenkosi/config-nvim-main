vim.pack.add({
	{
		src = "https://github.com/tkachenkosi/micro-snippets.nvim.git",
		name = "snippets",
		version = "master",
	},
})

require("snippets").setup()
