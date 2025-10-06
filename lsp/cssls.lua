return {
  name = "cssls", -- В Mason называется именно cssls
  -- cmd = { "vscode-css-language-server", "--stdio" },
  cmd = { os.getenv("HOME") .. "/.local/share/nvim/mason/bin/vscode-css-language-server", "--stdio" },
  init_options = { provideFormatter = true }, -- needed to enable formatting capabilities
	root_markers = { "package.json", "tsconfig.json", "vite.config.ts", ".git", ".session" },
  filetypes = { "css", "scss" },
  settings = {
    css = { validate = true },
    scss = { validate = true },
  },
}
