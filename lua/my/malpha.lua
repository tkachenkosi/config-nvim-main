local M = {}

-- vim.api.nvim_set_hl(0, "MyHighlight", {
--     fg = "#ff0000",        -- цвет текста
--     bg = "#0000ff",        -- цвет фона  
--     sp = "#ffff00",        -- цвет подчеркивания
--     ctermfg = 196,         -- терминальный цвет текста
--     ctermbg = 21,          -- терминальный цвет фона
--     bold = true,           -- жирный
--     italic = true,         -- курсив
--     underline = true,      -- подчеркивание
--     undercurl = true,      -- волнистое подчеркивание
--     strikethrough = true,  -- зачеркивание
--     reverse = true,        -- инвертировать цвета
--     blend = 50,            -- прозрачность (0-100)
--     default = false,       -- наследовать атрибуты
-- })

-- Значения по умолчанию
local config = {
	count_recent = 20,
	session_name = "/.session",
	pinned = {
		{"c", "~/.config/nvim/lua/core/configs.lua"},
		{"m", "~/.config/nvim/lua/core/mappings.lua"},
		{"l", "~/.config/nvim/lua/core/lsp.lua"},
		{"s", "~/.config/nvim/.session"},
	}
}

-- Утилита 1: Сократить путь (заменить $HOME)
local function shorten_path(path)
  local home = vim.fn.expand("~")
  return path:gsub("^" .. vim.pesc(home), "~")
end

-- проверяем что сессия существует
local function file_exists(file_path)
	return vim.fn.filereadable(file_path) == 1
end

-- Загрузить файл
local function load_path()
	local line = vim.api.nvim_get_current_line()
	local f =	string.sub(line, 1, 1)
	if f == ":" then
		local session =	vim.fn.expand(string.sub(line, 3))
    if file_exists(session..config.session_name) then
			vim.cmd("cd "..session)
			vim.cmd("so .session")
		end
	elseif f == "~" or f == "/" then
		local file = vim.fn.expand(line)
    if file_exists(file) then
			vim.cmd("edit "..file)
		end
	end
end

-- Функция запуска стартового экрана
function M.open()
  -- Создаём новый буфер
  vim.cmd("enew")
  local buf = vim.api.nvim_get_current_buf()

  -- Настраиваем его как "специальный"
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].modifiable = true
  vim.bo[buf].filetype = "startscreen"
  vim.bo[buf].buflisted = false
  vim.bo[buf].textwidth = 0

  local lines = {}

  --  Заголовок
  table.insert(lines, "© Config for nvim by Tkachenkosi. 2025")
  table.insert(lines, "")

  --  Новая сессия
  table.insert(lines, "[n] New file")
  table.insert(lines, "")

  -- Последние файлы
  local oldfiles = vim.v.oldfiles or {}
  for i = 1, math.min(config.count_recent, #oldfiles) do
    table.insert(lines, string.format("%s", shorten_path(oldfiles[i])))
  end
  table.insert(lines, "")

  -- Закреплённые
  for _, file in ipairs(config.pinned) do
    table.insert(lines, string.format("[%s] %s", file[1], file[2]))
  end
  table.insert(lines, "")

	-- Открываем файл сессий для чтения
	local file = io.open(vim.fn.expand("~/.config/nvim"..config.session_name), "r")
	if file then
			for line in file:lines() do
					table.insert(lines, string.format(": %s", line))
			end
			file:close()
	else
			table.insert(lines, "Ошибка: открытия файла для чтения "..config.session_name)
	end
  table.insert(lines, "<End start page>")

	-- Добавляем строки ---
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

	-- устанавливаем hl
	vim.api.nvim_set_hl(0, "MyHighlightPath", {
		fg = "#ada085",      -- GUI цвет
		ctermfg = 180,       -- Терминальный цвет
		default = true,   -- наследовать отсутствующие атрибуты
	})

	vim.api.nvim_set_hl(0, "MyHighlightTitle", {
		ctermfg = 180,
		bold = true,
		default = true,
	})

	-- Создаем namespace для хайлайтов
  local ns = vim.api.nvim_create_namespace("file_paths_highlights")
	-- Очищаем старые хайлайты в этом namespace
  -- vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

	-- Проходим по всем строкам
	for i, line in ipairs(lines) do
		-- Ищем последний слэш в пути (для выделения имени файла)
		local last_slash_pos = line:find("/[^/]*$")

		if last_slash_pos then

			-- Выделяем путь ДО имени файла (от начала до последнего слэша)
			-- Добавляем экстмарк с хайлайтом
			vim.api.nvim_buf_set_extmark(
				buf,           -- номер буфера
				ns,				     -- namespace
				i - 1,         -- строка (0-based)
				0,             -- колонка начала
				{
					end_row = i - 1,       -- конечная строка
					end_col = last_slash_pos, -- конечная колонка
					hl_group = "MyHighlightPath", -- группа хайлайта
					hl_eol = false,        -- не подсвечивать до конца строки
				}
			)

		end
	end

	-- выделяем первую строку
	vim.api.nvim_buf_set_extmark(
		buf,ns,0,0,
		{
			end_row = 0,
			end_col = #lines[1],
			hl_group = "MyHighlightTitle",
			hl_eol = false,
		}
	)

  vim.bo[buf].modifiable = false

  -- Привязка клавиш
  local opts = { noremap = true, silent = true, buffer = buf }
  vim.keymap.set("n", "n", ":enew<CR>", opts)

  -- recent files
  -- for i = 1, math.min(10, #oldfiles) do
  --   vim.keymap.set("n", tostring(i), function()
  --     vim.cmd("edit " .. oldfiles[i])
  --   end, opts)
  -- end

  -- pinned
  for _, file in ipairs(config.pinned) do
    vim.keymap.set("n", file[1], function() vim.cmd("edit " .. file[2]) end, opts)
  end

	vim.keymap.set("n", "q", "<cmd>qa<CR>", opts)
	vim.keymap.set("n", "<CR>", function() load_path() end, opts)
end

function M.setup(options)
	options = options or {}

	-- Обновляем конфигурацию с пользовательскими настройками
	config.count_recent = options.count_recent or config.count_recent
	config.session_name = options.session_name or config.session_name

	-- Обновляем pinned файлы, если они предоставлены
	if options.pinned then
		config.pinned = options.pinned
	end

	-- Можно добавить валидацию значений
	if config.count_recent < 10 then
		config.count_recent = 10
		vim.notify("count_recent не может быть меньше 10", vim.log.levels.WARN)
	end
end

-- В конец модуля, перед return M
function M.enable_autostart()
	local group = vim.api.nvim_create_augroup("malpha.nvim", { clear = true })

	vim.api.nvim_create_autocmd("VimEnter", {
		group = group,
		callback = function()
			-- Запускаем только если:
			-- - Нет аргументов командной строки
			-- - Не восстанавливается сессия
			if vim.fn.argc() == 0 and vim.v.this_session == "" then
					M.open()
			end
		end
	})
end


-- пример запуска в init.lua
-- local startscreen = require("startscreen")
-- startscreen.setup({
    -- count_recent = 20,
-- })
-- startscreen.enable_autostart()

-- для настройки
-- vim.keymap.set('n', '<F9>', function() M.open() end, {})
return M

