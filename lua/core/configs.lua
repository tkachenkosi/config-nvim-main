vim.wo.number = true
-- vim.wo.relativenumber = true
vim.opt.mouse = "a"
vim.opt.mousefocus = true
vim.opt.clipboard = "unnamedplus"

vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.smartindent = true  -- что то для отступов в новой строке
vim.opt.autoindent = true		-- копирует отступы с текущей строки при добавлении новой
vim.opt.breakindent = true	-- позволяет сохранять отступы виртуальных строк

vim.opt.encoding="utf-8"
vim.opt.fileformat="unix"

vim.opt.scrolloff = 3
vim.opt.wrap = false
vim.opt.termguicolors = true
vim.opt.background = "dark" -- or "light" for light mode

vim.opt.updatetime = 20000
vim.opt.timeoutlen = 1600
vim.opt.undolevels = 200
vim.opt.history = 300

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.wo.foldmethod = 'marker'

-- настройки для встоенного Exploer
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 4

-- Не понятные настройки
-- opt.cursorline = true
vim.wo.signcolumn = 'yes'
-- vim.opt.hlsearch = true
-- vim.opt.hidden = true

vim.opt.cursorline = true -- Включаем подсветку текущей строки

vim.opt.laststatus = 2
vim.opt.showmode = false
vim.opt.shortmess:append("sIc")
vim.opt.synmaxcol = 500

-- настройки для treesister
vim.opt.syntax = "OFF"  -- ВСЕ ЗАГЛАВНЫЕ (иногда важно)
vim.opt_global.syntax = "OFF"
vim.cmd("syntax off")   -- Дублируем командой на всякий случай


-- Глобальный флаг: "extended" или "minimal"
_G.LspStatusMode = _G.LspStatusMode or 0

_G.MyLspStatus = function()
  if _G.LspStatusMode == 0 then
    return ""
  end

  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    return "-"
  end

  -- Расширенный режим: имена клиентов + диагностика
  if _G.LspStatusMode == 1 then
		local names = {}
		for _, client in ipairs(clients) do
			table.insert(names, client.name)
		end
		local lsp_name = table.concat(names, ",")
			-- возвращаем только имя клиента LSP
			return lsp_name
  end

  local diagnostics = vim.diagnostic.get(0)
  local errors, warnings = 0, 0
  for _, d in ipairs(diagnostics) do
    if d.severity == vim.diagnostic.severity.ERROR then
      errors = errors + 1
    elseif d.severity == vim.diagnostic.severity.WARN then
      warnings = warnings + 1
    end
  end

	if errors == 0 and warnings == 0 then
		return ":"
	end
	return string.format("E:%d W:%d", errors, warnings)
end

-- Переключение режима показа статуса LSP в statusline
vim.keymap.set("n", "<leader>l", function()
  _G.LspStatusMode = (_G.LspStatusMode + 1) % 3

	local labels = { [0] = "off", [1] = "name", [2] = "diagnostics" }
  vim.cmd("redrawstatus")
  vim.notify("LSP status: " .. labels[_G.LspStatusMode], vim.log.levels.INFO)
end, { desc = "Toggle LSP status mode" })

-- HL statusline
for group, color in pairs({
	mode = {bg = '#ada299', fg = '#002fbb', bold = true},
	file = {bold = true},
	modi = {bg = '#e9c76b', fg = '#662227', bold = true},
	buff = {bg = '#ada299', fg = '#002fbb'},
	line = {bg = '#ada299'},
	lines = {bg = '#c4bcb5'}}) do
	vim.api.nvim_set_hl(0, "HL_"..group, color)
end

vim.opt.statusline = table.concat({
  "%#HL_mode# %-3{%v:lua.vim.fn.mode()%}%*",
  "%#HL_file# %-.50f%* ",
  "%#HL_modi#%-M%*",
  "%=",
  "%#HL_line# %{v:lua.MyLspStatus()} %*", -- <-- LSP-индикатор
  "%#HL_buff#%n%*",
  "%#HL_line# %l:%v %*",
  "%#HL_lines#%L%*"}, "")

