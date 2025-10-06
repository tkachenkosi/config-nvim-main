return {
	name = "ts_ls",
	-- cmd = { "typescript-language-server", "--stdio" },
	cmd = { os.getenv("HOME") .. "/.local/share/nvim/mason/bin/typescript-language-server", "--stdio" },
	filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact", "svelte" },
	root_markers = { "package.json", "tsconfig.json", "jsconfig.json", "vite.config.ts", ".git", ".session" },
	single_file_support = false,
	settings = {
		javascript = {
			suggest = {
				completeFunctionCalls = true,
			},
			implicitProjectConfig = {
				checkJs = false,       -- 🚫 отключить строгую проверку JS
				strictNullChecks = false, -- опционально: не проверять null
			},
		},
		typescript = {
			inlayHints = {
				includeInlayParameterNameHints = "all",
				includeInlayVariableTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
			},
		},
	},
}
