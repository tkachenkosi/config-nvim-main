-- Глобальный флаг: "extended" или "minimal"
_G.LspStatusMode = _G.LspStatusMode or 0

-- Ветка git. Показывает branch в сообщении командной строки.
local function getBranch()
	local res, br = vim.fn.systemlist("git branch --show-current"), "None"
	if #res > 0 and #res[1]<20 then
		br = res[1]
	end
	return ", Git: " .. br
end

-- возвращает только имя LSP
local function getNameLsp()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    return "None"
  end

  -- Расширенный режим: имена клиентов + диагностика
	local names = {}
	for _, client in ipairs(clients) do
		table.insert(names, client.name)
	end
	local lsp_name = table.concat(names, ",")
	-- возвращаем только имя клиента LSP
	return lsp_name
end


-- диагностика LSP показываем только количество ошибок и предупреждений
_G.MyLspStatus = function()
  if _G.LspStatusMode < 1 then
    return ""
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
  _G.LspStatusMode = (_G.LspStatusMode + 1) % 2

	local labels = { [0] = "off", [1] = getNameLsp() .. getBranch() }
  vim.cmd("redrawstatus")
  vim.notify("Lsp: " .. labels[_G.LspStatusMode], vim.log.levels.INFO)
end, { noremap = true, silent = true, desc = "Toggle LSP status mode" })


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
  "%#HL_line# %v:%p%%/%*",
  "%#HL_lines#%L%*"}, "")

