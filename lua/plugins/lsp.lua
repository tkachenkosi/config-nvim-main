return {
  {
    'neovim/nvim-lspconfig',
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup{
				settings = {
					Lua = {
						diagnostics = {
							-- Get the language server to recognize the `vim` global
							globals = {'vim'},
						},
					},
				},
			}
      lspconfig.gopls.setup({})
			lspconfig.ts_ls.setup({})
			lspconfig.clangd.setup({})
			lspconfig.html.setup({})
			lspconfig.cssls.setup({})
			lspconfig.svelte.setup({})
			lspconfig.rust_analyzer.setup({})
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

					local opts = { buffer = ev.buf }
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)                     -- переходит к определинию метода
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)                           -- показывает определение метода 
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "<Leader>D", vim.lsp.buf.type_definition, opts)         -- переходит к определению типа возвращаемого методом
          vim.keymap.set('n', 'qr', vim.lsp.buf.references, opts)                     -- показывает в одтельном окне все ссылки где используется переменная или метод
					vim.keymap.set("n", "<Leader>lr", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename Symbol" })
  				vim.keymap.set({ "n", "v" }, "<Leader>la", vim.lsp.buf.code_action, opts)   -- добовляет достающие методы в импорт
					vim.keymap.set("n", "<Leader>lf", function()
						vim.lsp.buf.format({ async = true })
					end, opts)
				end,
			})


    end
  }
}

--[[
K - показывает определение метода (его параметры и тип возвращаемого значения)
gd - переходит к определинию метода или функции
<lider>-D - переходит к определинию метода или функции
<lider>-lr - переименование метода или функции
gi - переходит к определению типу значеня, возвращаемого методом
qr - показывает в одтельном окне все ссылки где используется переменная или метод
]]

