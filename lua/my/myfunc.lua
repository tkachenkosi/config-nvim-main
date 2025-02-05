-- Подробная документация по LUA на русском
-- https://linuxshare.ru/docs/devel/languages/lua/reference/index.html
-- https://gcup.ru/publ/programming/lua_dlja_vsej_semi_urok_5_rabota_so_strokami/8-1-0-513
-- https://gcup.ru/publ/programming/lua_tutorial_dlja_nachinajushhikh_chast_4/8-1-0-626


local M = {}
-- local buf, win


local filter_text = ""

vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2b2b2b" })

local tab_snippet_err = {'if err != nil {','  slog.Error(err.Error())','  return fmt.Errorf("ошибка %v", err)','}'}
local tab_snippet_main = {'func main() {','  fmt.Println("")','}'}
local tab_snippet_struct = {'type  struct {}','}'}
local tab_snippet_range = {'for k,v := range  {','}'}

local function print_snippet(lines)
    -- Получаем текущую позицию курсора
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local row, col = cursor_pos[1], cursor_pos[2]

    table.insert(lines, '')

		-- Вставляем строки после текущей позиции курсора
		vim.api.nvim_buf_set_lines(0, row, row, false, lines)

		-- Перемещаем курсор на новую строку
		vim.api.nvim_win_set_cursor(0, {row + #lines, col})
end

vim.keymap.set({'n','i'}, '<a-1>', function() print_snippet(tab_snippet_err) end)
vim.keymap.set({'n','i'}, '<a-3>', function() print_snippet(tab_snippet_main) end)
vim.keymap.set({'n','i'}, '<a-4>', function() print_snippet(tab_snippet_range) end)


-- Функция для сохранения текущей строки в переменную
local function gen_json_current_line()
		local line = vim.api.nvim_get_current_line()

		-- проверяем что в строке нет json
		if string.find(line, 'json', 2) == nil then
			-- поиск пробела с конца строки
			local x,_ = string.find(line, ' ', 2)
			if x ~= nil and x > 2 then
				-- выдиляем имя поля структуры, также удаляем все пробелы и символы перевода
				local field = string.lower(string.gsub(string.sub(line, 1, x), "%s+", ""))
				vim.api.nvim_set_current_line(line .. ' `json:"' .. field .. '"`')
				-- перемещаем курсор вниз
				vim.cmd('norm! j')
			end
    end
end

-- Создаём команду для вызова функции
-- vim.api.nvim_create_user_command("JsonLine", gen_json_current_line, {})
-- vim.api.nvim_set_keymap('n', '<a-2>', "<CMD>JsonLine<CR>")
vim.keymap.set({'n','i'}, '<a-2>', function() gen_json_current_line() end)


local function find_buffers()
  local results = {}
  local buffers = vim.api.nvim_list_bufs()

  for _, buffer in ipairs(buffers) do
    if vim.api.nvim_buf_is_loaded(buffer) then
      local filename = vim.api.nvim_buf_get_name(buffer)
      table.insert(results, filename)
			-- print(filename)
    end
  end
	return results
end


-- Функция для создания плавающего окна
local function create_floating_window()
    -- Получаем размеры экрана
    local width = vim.api.nvim_get_option("columns")
    local height = vim.api.nvim_get_option("lines")

    -- Вычисляем размеры окна (50% экрана)
    local win_width = math.floor(width * 0.5)
    local win_height = math.floor(height * 0.5)

    -- Вычисляем позицию окна (центр экрана)
    local row = math.floor((height - win_height) / 2)
    local col = math.floor((width - win_width) / 2)

    -- Создаём буфер для окна
    local buf = vim.api.nvim_create_buf(false, true)

    -- Создаём плавающее окно
    local opts = {
        relative = "editor",
        width = win_width,
        height = win_height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
				title = "Плавающее окно", -- Заголовок окна
        title_pos = "center",     -- Позиция заголовка
    }
    local win = vim.api.nvim_open_win(buf, true, opts)

    -- Устанавливаем клавишу Esc для закрытия окна
    vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":q!<CR>", { noremap = true, silent = true })

    -- Устанавливаем текст в буфере
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
        "Это плавающее окно.",
        "Нажмите Esc, чтобы закрыть его.",
        "В чащах юга жил был цитрус, да но фальшивый экземпляр.",
        "Проверка работы с буфером и окном.",
    })

    -- vim.api.nvim_buf_set_lines(buf, 0, -1, false, get_bufs_loaded())
    -- vim.api.nvim_buf_set_lines(buf, 0, -1, false, find_buffers())
    local myTable = find_buffers()
		for key, value in pairs(myTable) do
			vim.api.nvim_buf_set_lines(buf, 7, 7, false, {value,})
			-- print(key, value)
		end

		-- Определяем синтаксическую группу для красного текста
    vim.cmd("highlight RedText guifg=red ctermfg=red") -- Красный текст
    vim.cmd("highlight BlueBgRedText guifg=red guibg=blue ctermfg=red ctermbg=blue") -- Красный текст на синем фоне

    -- Применяем красный цвет к тексту
    vim.api.nvim_buf_add_highlight(buf, -1, "BlueBgRedText", 0, 0, -1) -- Первая строка
    vim.api.nvim_buf_add_highlight(buf, -1, "RedText", 1, 0, -1) -- Вторая строка


		-- Устанавливаем режим "только для чтения"
    vim.api.nvim_buf_set_option(buf, "readonly", true)
    vim.api.nvim_buf_set_option(buf, "modifiable", false)

-- Открыть терминал
-- vim.cmd("term")

-- Получить ID терминала
-- local term_id = vim.b.terminal_job_id

-- Отправить команду в терминал
-- vim.api.nvim_chan_send(term_id, "echo 'Hello from Lua!'\n")
end

-- Создаём команду для вызова функции
vim.api.nvim_create_user_command("FloatWindow", create_floating_window, {})


-- Функция для получения имени файла и его расширения
local function get_file_info()
    -- Получаем полный путь к текущему файлу
    local file_path = vim.api.nvim_buf_get_name(0)

    -- Извлекаем имя файла из пути
    local file_name = file_path:match("([^/\\]+)$")

    -- Извлекаем расширение файла
    local file_extension = file_name:match("^.+(%..+)$")

    -- Если расширение не найдено, возвращаем nil
    if not file_extension then
        file_extension = "нет расширения"
    end

    -- Возвращаем имя файла и расширение
    return file_name, file_extension
end

-- local file_path = vim.api.nvim_buf_get_name(0)
-- if file_path == "" then
--     print("Файл не сохранён или не имеет имени.")
--     return
-- end

-- Основная функция
local function print_file_info()
    local file_name, file_extension = get_file_info()
    print("Имя файла: " .. file_name .. "  Расширение файла: " .. file_extension)
    -- print("Расширение файла: " .. file_extension)
    -- print(vim.api.nvim_buf_get_name(0))
    -- print(get_bufs_loaded())
		print(find_buffers()[1])
end

-- Создаём команду для вызова функции
vim.api.nvim_create_user_command("FileInfo", print_file_info, {})

-- Функция для получения списка открытых буферов
local function get_open_buffers2()
    local buffers = {}
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) then -- Проверяем, что буфер загружен
            local file_name = vim.api.nvim_buf_get_name(buf) -- Получаем имя файла
            table.insert(buffers, file_name)
        end
    end
    return buffers
end


local function get_buffer_info(buf)
    -- Проверяем, что буфер валиден
    if not vim.api.nvim_buf_is_valid(buf) then
        return "Буфер не валиден"
    end

    -- Собираем информацию о буфере
    local info = {
        loaded = vim.api.nvim_buf_is_loaded(buf), -- Загружен ли буфер
        valid = vim.api.nvim_buf_is_valid(buf),   -- Валиден ли буфер
        name = vim.api.nvim_buf_get_name(buf),    -- Имя файла буфера
        number = vim.api.nvim_buf_get_number(buf), -- Номер буфера
        modified = vim.api.nvim_buf_get_option(buf, "modified"), -- Изменён ли буфер
        line_count = vim.api.nvim_buf_line_count(buf), -- Количество строк в буфере
        filetype = vim.api.nvim_buf_get_option(buf, "filetype"), -- Тип файла
        readonly = vim.api.nvim_buf_get_option(buf, "readonly"), -- Только для чтения
        buftype = vim.api.nvim_buf_get_option(buf, "buftype"), -- Тип буфера (например, "nofile")
        -- list = vim.api.nvim_buf_get_option(buf, "list"), -- Отображение невидимых символов
        swapfile = vim.api.nvim_buf_get_option(buf, "swapfile"), -- Используется ли файл подкачки
        undolevels = vim.api.nvim_buf_get_option(buf, "undolevels"), -- Уровни отмены
        tagstack = vim.fn.getbufvar(buf, "&tagstack"), -- Стек тегов
    }

    return info
end




-- Функция для получения списка открытых буферов с номерами и атрибутами
local function get_open_buffers()
    local buffers = {}
    local current_buf = vim.api.nvim_get_current_buf() -- Текущий активный буфер
    local previous_buf = vim.fn.bufnr("#")             -- Предыдущий буфер
		local root_dir = vim.fn.getcwd() .. "/"

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        -- if vim.api.nvim_buf_is_loaded(buf) then -- Проверяем, что буфер загружен
            -- local file_name = vim.api.nvim_buf_get_name(buf) -- Получаем имя файла
            local file_name = string.gsub(vim.api.nvim_buf_get_name(buf), root_dir, "") -- Получаем имя файла
            local buf_number = vim.api.nvim_buf_get_number(buf) -- Номер буфера
						local is_modified = vim.api.nvim_buf_get_option(buf, "modified")

            -- Определяем атрибуты буфера
            local attributes = {}
            if buf == current_buf then
                table.insert(attributes, "%")
            end
            if buf == previous_buf then
                table.insert(attributes, "#")
            end
            if #attributes == 0 then
                table.insert(attributes, " ")
						end
						if is_modified then
                table.insert(attributes, "+")
						else
                table.insert(attributes, " ")
						end

            -- Формируем строку с информацией о буфере
            local buffer_info = string.format(" %3d %s %s", buf_number, table.concat(attributes, ""), file_name)

            -- if #attributes > 0 then
            --     buffer_info = buffer_info .. " (" .. table.concat(attributes, ", ") .. ")"
            -- end

						-- временно добовляем короткое имя файла (относительно текущего каталога)
						-- local short_name = string.gsub(file_name, root_dir, "")
						-- buffer_info = buffer_info .. " [" .. short_name .. "]"

            table.insert(buffers, buffer_info)

					-- vim.fn.bufload(buf_number)

					-- if not vim.api.nvim_buf_is_loaded(buf) then -- Проверяем, что буфер загружен
						-- vim.fn.bufload(buf)
					-- end

			local info = get_buffer_info(buf)
			for key, value in pairs(info) do
         table.insert(buffers, string.format("%s: %s", key, vim.inspect(value)))
			end

         table.insert(buffers, string.format("buflisted: %s", vim.inspect(vim.fn.buflisted(buf_number))))
         table.insert(buffers, string.format("bufexists: %s", vim.inspect(vim.fn.bufexists(buf_number))))



        -- end
    end

    return buffers
end

-- зкрыть буфер
local function close_buffer()
	local buf = vim.api.nvim_get_current_buf() -- Получаем текущий буфер
	vim.api.nvim_buf_delete(buf, { force = true }) -- Закрываем буфер
end

-- Функция для выбора буфера
local function select_buffer()
		local buf_number = tonumber(string.sub(vim.api.nvim_get_current_line(), 2, 4))
		close_buffer()
    -- Переключаемся на выбранный буфер
    vim.api.nvim_set_current_buf(vim.fn.bufnr(buf_number))
end

-- Функция для обработки ввода символов
local function handle_char(char)
    -- vim.g.filter_text = vim.g.filter_text .. char
    -- vim.g.update_filter()
    filter_text = filter_text .. char
		print(filter_text)
		local buf = vim.api.nvim_get_current_buf() -- Получаем текущий буфер
		local line_count = vim.api.nvim_buf_line_count(buf)
		vim.api.nvim_buf_set_lines(buf, line_count, line_count, false, {"= " .. filter_text})
end

-- Функция для создания нового окна и вывода списка буферов
local function print_buffers_to_window()
    -- Получаем список открытых буферов
    local buffers = get_open_buffers()

    -- Создаём новый буфер
    local buf = vim.api.nvim_create_buf(false, true)

    -- Устанавливаем текст в буфере
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, buffers)

    -- Создаём новое окно
    local width = math.floor(vim.o.columns * 0.8) -- 80% ширины экрана
    local height = math.floor(vim.o.lines * 0.8)  -- 80% высоты экрана
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)
		-- vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2e2e2e" })
		-- vim.api.nvim_set_hl(0, "CursorLine", { bg = "#112233" })
		-- vim.api.nvim_win_set_option(0, "cursorline", true) -- Включаем подсветку текущей строки

    local opts = {
        -- relative = "editor",
        relative = "win",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
        title = "[" .. vim.api.nvim_buf_line_count(buf) .. ":" .. vim.fn.getcwd() .. "]",
        title_pos = "center",      -- Позиция заголовка
    }

    -- Открываем окно
    local win = vim.api.nvim_open_win(buf, true, opts)

		-- vim.api.nvim_out_write({"test"})
		-- nvim_set_current_dir({dir})
		-- nvim_set_hl({ns_id}, {name}, {val}) 

		-- Количество строк в буфере
		-- local line_count = vim.api.nvim_buf_line_count(buf)
		-- vim.api.nvim_buf_set_lines(buf, line_count, line_count, false, {"количество строк = " .. line_count})



    -- Устанавливаем режим "только для чтения"
    vim.api.nvim_buf_set_option(buf, "readonly", true)
    vim.api.nvim_buf_set_option(buf, "modifiable", false)


    -- vim.g.select_buffer = select_buffer


    -- Устанавливаем клавишу Esc для закрытия окна
    -- vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":q!<CR>", { noremap = true, silent = true })
    -- vim.api.nvim_buf_set_keymap(buf, "n", "q", "<CMD>CloseWinBuffer<CR>", { noremap = true, silent = true })
    -- vim.api.nvim_buf_set_keymap(buf, "n", "q", "<CMD>TitleWinBuffer<CR>", { noremap = true, silent = true })
    -- vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", function() close_buffer() end, { noremap = true, silent = true })
    -- vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", [[<cmd>lua close_buffer()<cr>]], { noremap = true, silent = true })
-- keymap('n', '<leader>ff', [[<cmd>lua require('telescope.builtin').find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<CR>]], { noremap = true, silent = true })

    -- vim.api.nvim_buf_set_keymap(buf, "n", "<CR>",	":lua require('buffers').select_buffer()<CR>", { noremap = true, silent = true })


    -- vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "<CMD>CloseWinBuffer<CR>", { noremap = true, silent = true })
    -- vim.api.nvim_buf_set_keymap(buf, "n", "<CR>",	"<CMD>SelectBuffer<CR>", { noremap = true, silent = true })

    vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", [[<CMD>lua require('my.myfunc').close_buffer()<CR>]], { noremap = true, silent = true })
		-- vim.api.nvim_buf_set_keymap(buf, "n", "<CR>",	[[<CMD>lua require('my.myfunc').select_buffer()<CR>]], { noremap = true, silent = true })
		vim.api.nvim_buf_set_keymap(buf, "n", "<CR>",	require('my.myfunc').select_buffer, { noremap = true, silent = true })


    -- vim.api.nvim_buf_set_keymap(buf, "n", "<Char>", ":lua require('my.myfunc').handle_char(vim.fn.nr2char(vim.v.char))<CR>", { noremap = true, silent = true })
    -- vim.api.nvim_buf_set_keymap(buf, "n", "<lhs>", ":lua require('my.myfunc').handle_char(vim.fn.nr2char(vim.v.char))<CR>", { noremap = true, silent = true })

end

-- vim.g.select_buffer = select_buffer

-- Создаём команду для вызова функции
vim.api.nvim_create_user_command("ListBuffers", print_buffers_to_window, {})
vim.api.nvim_create_user_command("CloseWinBuffer", close_buffer, {})
-- vim.api.nvim_create_user_command("SelectBuffer", select_buffer, {})
-- vim.api.nvim_create_user_command("TitleWinBuffer", title_buffer, {})



-- M.create_live_win = create_live_win
M.handle_char = handle_char
-- M.handle_backspace = handle_backspace
M.close_buffer = close_buffer
M.select_buffer = select_buffer
return M
