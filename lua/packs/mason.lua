vim.pack.add({
	{
		src = "https://github.com/mason-org/mason.nvim.git",
		name = "mason.nvim",
		version = "main",
	},
})

require("mason").setup({
	ui = {
    -- border = "rounded",
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗"
		},
	},
  max_concurrent_installers = 4,
})

