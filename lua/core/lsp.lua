-- список серверов
local servers = {
    "lua_ls",
    "gopls",
    "ts_ls",
    "html",
    "cssls",
    "svelte",
		"clangd",
		"rust_analyzer",
}

-- грузим конфиги серверов из /lsp
-- for _, server in ipairs(servers) do
	-- local ok, opts = pcall(require, "lsp." .. server)
	-- if ok then
		-- vim.lsp.config(server, opts)
	-- else
		-- vim.notify("⚠ Не найден конфиг для " .. server, vim.log.levels.INFO)
	-- end
-- end

-- активируем их
vim.lsp.enable(servers)

-- === Настройки автодополнения (без nvim-cmp) ===
vim.opt.completeopt = { "menu", "menuone", "noselect", "popup", "fuzzy" }

-- Общие keymaps при LspAttach
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local opts = { buffer = ev.buf }

		-- Автодополнение только если сервер поддерживает его
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })

			-- Вручную вызвать меню
      vim.keymap.set('i', '<C-Space>', function()
        vim.lsp.completion.get()
      end, { buffer = ev.buf, desc = "LSP Completion" })
    end

		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "<Leader>D", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "qr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<Leader>lr", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename Symbol" })
		vim.keymap.set({ "n", "v" }, "<Leader>la", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "<Leader>lf", function()
				vim.lsp.buf.format({ async = true })
		end, opts)

  end,
})

vim.diagnostic.config({
  -- Use the default configuration
  -- virtual_lines = true

  -- Alternatively, customize specific options
  update_in_insert = false,
  -- underline = true,
  virtual_lines = {
    -- Only show virtual line diagnostics for the current cursor line
    current_line = true,
  },
})
