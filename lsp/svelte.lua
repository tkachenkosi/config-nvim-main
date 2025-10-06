return {
  name = "svelte",
  -- cmd = { "svelteserver", "--stdio" },
  cmd = { os.getenv("HOME") .. "/.local/share/nvim/mason/bin/svelteserver", "--stdio" },
  filetypes = { "svelte" },
	root_markers = { "package.json", "tsconfig.json", "vite.config.ts", ".git", ".session" },
  settings = {
    svelte = {
      plugin = {
        svelte = {
          compilerWarnings = {
            ["a11y-no-onchange"] = "ignore", -- пример отключения ворнинга
          },
        },
        typescript = {
          diagnostics = { enable = true },
          inlayHints = {
            parameterTypes = true,
            variableTypes = true,
            propertyDeclarationTypes = true,
            functionLikeReturnTypes = true,
            enumMemberValues = true,
          },
        },
      },
    },
  },
}
