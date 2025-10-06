return {
  name = "html",
  -- cmd = { "vscode-html-language-server", "--stdio" },
  cmd = { os.getenv("HOME") .. "/.local/share/nvim/mason/bin/vscode-html-language-server", "--stdio" },
  filetypes = { "html" },
	root_markers = { "package.json", "tsconfig.json", "vite.config.ts", ".git", ".session" },
  settings = {
    html = {
      format = { enable = true },
      validate = { scripts = true, styles = true },
    },
  },
  init_options = {
    provideFormatter = true,
    embeddedLanguages = { css = true, javascript = true },
    configurationSection = { 'html', 'css', 'javascript' },
  },
}
