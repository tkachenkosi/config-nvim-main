return {
	name = "clangd",
	-- cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=never" },
	cmd = { os.getenv("HOME") .. "/.local/share/nvim/mason/bin/clangd", "--background-index", "--clang-tidy", "--header-insertion=never" },
	filetypes = { "c", "cpp", "objc", "objcpp" }, -- работает только на C/C++
	root_markers = { ".clangd", "compile_commands.json", ".clang-format", ".git", ".session" },
  capabilities = {
    textDocument = {
      completion = {
        editsNearCursor = true,
      },
    },
    offsetEncoding = { 'utf-8', 'utf-16' },
  },
	init_options = {
    fallbackFlags = { "-std=c++17" },
    clangdFileStatus = true,
    fallbackStyle = "{ BasedOnStyle: LLVM, ColumnLimit: 0 }",
  },
}
