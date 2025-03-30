-- не коментиовать в новой строке (когда создаем новую строку)
vim.cmd([[autocmd BufEnter * set fo-=c fo-=r fo-=o]])

-- кратковременно подсвечивает скопированную строку или блок
local YankHighlightGrp = vim.api.nvim_create_augroup('YankHighlightGrp', {})
vim.api.nvim_create_autocmd('TextYankPost', {
	group = YankHighlightGrp,
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({
      higroup = 'IncSearch',
      timeout = 30,
    })
  end,
})

-- форматирование файлов go css js на запись
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = {'*.go', '*.css', '*.js', '*.ts', '*.svelte'},
  callback = function()
    vim.lsp.buf.format({ async = false })
  end
})


