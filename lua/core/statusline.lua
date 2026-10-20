-- Глобальный флаг: "extended" или "minimal"
_G.LspStatusMode = _G.LspStatusMode or 0

-- ветка git
-- local function current_branch()
-- 	local res = vim.fn.systemlist("git branch --show-current")
-- 	if #res == 0 or #res[1]>20 then
-- 		return "Git None"
-- 	end
-- 	return res[1]
-- end

-- диагностика LSP
_G.MyLspStatus = function()
  if _G.LspStatusMode == 0 then
    return ""
  end

  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    return "LSP None"
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

	--  if _G.LspStatusMode == 2 then
	-- 	return current_branch()
	-- end

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

	local labels = { [0] = "off", [1] = "name", [2] = "git", [3] = "diagnostics" }
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

