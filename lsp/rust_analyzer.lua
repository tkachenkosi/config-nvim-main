return {
	name = "rust-analyzer",
	-- cmd = { "rust-analyzer" },
	cmd = { os.getenv("HOME") .. "/.local/share/nvim/mason/bin/rust-analyzer" },
	root_markers = { ".git", ".session" },
	filetypes = { "rust" },
  settings = {
        ["rust-analyzer"] = {
            cargo = { allFeatures = true },
            checkOnSave = { command = "clippy" },
        },
    },
}
