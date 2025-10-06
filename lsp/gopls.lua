return {
	name = "gopls",
	-- cmd = { "gopls" },
	cmd = { os.getenv("HOME") .. "/.local/share/nvim/mason/bin/gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl", "gosum" }, -- File types that this server will handle
	root_markers = { "go.mod", "go.work", ".git", ".session" },      -- Markers to identify the root of the project
	settings = {
		gopls = {
			gofumpt = true,
			usePlaceholders = true, -- автогенерация аргументов функций
			completeUnimported = true, -- автодобавление import при completion
			-- Автодобавление нужных import
			importShortcut = "Both",

			-- Диагностика + анализаторы
			analyses = {
				unusedparams = true,
				nilness = true,
				shadow = true,
				printf = true,
				structtag = true,
				slog = true,
				bools = true,
				assign = true,
				atomic = true,
			},
			staticcheck = true,
			directoryFilters = { "-.git", "-node_modules", "-testdata" },
			semanticTokens = true,
		},
	},
}
