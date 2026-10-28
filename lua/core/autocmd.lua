-- не коментиовать в новой строке (когда создаем новую строку)
vim.cmd([[autocmd BufEnter * set fo-=c fo-=r fo-=o]])

-- кратковременно подсвечивает скопированную строку или блок
-- local YankHighlightGrp = vim.api.nvim_create_augroup('YankHighlightGrp', {})

-- vim.api.nvim_create_autocmd('TextYankPost', {
-- 	group  = vim.api.nvim_create_augroup('YankHighlightGrp', {}),
--   pattern = '*',
--   callback = function()
--     vim.highlight.on_yank({
--       higroup = 'IncSearch',
--       timeout = 30,
--     })
--   end,
-- })


vim.api.nvim_create_autocmd('TextYankPost', {
	pattern = "*",
  desc = 'Highlight when yanking (copy) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank({
      timeout = 50,
		})
  end,
})


-- форматирование файлов go css js на запись
-- pattern = {'*.go', '*.css', '*.js', '*.ts', '*.svelte'},
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = {'*.go', '*.css', '*.js', '*.ts'},
  callback = function()
    vim.lsp.buf.format({ async = false })
  end
})


-- Добавьте этот автокоманд
-- vim.api.nvim_create_autocmd("FileType", {
--     pattern = "go",
--     callback = function()
--         vim.opt_local.syntax = "OFF"
--         vim.cmd("syntax off")
--         vim.cmd("setlocal syntax=OFF")
--     end
-- })


-- Регистрируем парсер 'bash' для всех файлов с типом 'sh'
vim.treesitter.language.register('bash', 'sh')
vim.treesitter.language.register('bash', 'conf')

-- Автоматически запускаем подсветку для этих файлов при открытии
-- local bashGroup = vim.api.nvim_create_augroup('BashHighlight', { clear = true })
-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = { 'sh', 'bash' },
--   group = bashGroup,
--   callback = function(args)
--     -- На всякий случай проверяем, не активна ли уже подсветка
--     if not vim.treesitter.highlighter.active[args.buf] then
--       pcall(vim.treesitter.start, args.buf)
--     end
--   end,
-- })


-- disable treesitter for large files
local MAX_LINES = 5000

-- Start treesitter. 
vim.api.nvim_create_autocmd('FileType', {
  callback = function(ev)
		-- checking the file size
		if vim.api.nvim_buf_line_count(ev.buf) > MAX_LINES then
			-- возврат подсветки на regex
			vim.treesitter.stop(ev.buf)
			vim.bo[ev.buf].syntax = "on"
			return
		end

		-- не дергать start() повторно
    if not vim.treesitter.highlighter.active[ev.buf] then
			-- vim.bo[ev.buf].syntax = "off"
      pcall(vim.treesitter.start, ev.buf)
    end
  end,
})

