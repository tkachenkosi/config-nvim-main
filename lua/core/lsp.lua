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
-- не показывать окно документации (описание функций)
-- vim.opt.completeopt = { "menu", "menuone", "noselect", "fuzzy" }
vim.lsp.completion.document_enable = false

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

		vim.keymap.set("n", "grd", vim.lsp.buf.definition, opts)
		-- vim.keymap.set("n", "<Leader>D", vim.lsp.buf.type_definition, opts)

  end,
})

vim.diagnostic.config({
	-- virtual_text = true,
	virtual_text = { current_line = true },

  update_in_insert = false,
  -- underline = true,

  -- virtual_lines = true
  -- virtual_lines = { current_line = true },
})
