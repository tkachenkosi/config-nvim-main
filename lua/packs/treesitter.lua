vim.pack.add({
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "master",
  },
})

require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"c", "cpp","lua","typescript","javascript",
		"query","rust","go","css","html","json","make","sql",
		"toml","bash","markdown","dockerfile","svelte"
	},
	auto_install = true,
	sync_install = false,
	highlight = { enable = true, additional_vim_regex_highlighting = false, },
	injection = { enable = false, },
	indent = { enable = false, },
})

