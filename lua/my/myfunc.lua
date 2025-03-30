-- Подробная документация по LUA на русском
-- https://linuxshare.ru/docs/devel/languages/lua/reference/index.html
-- https://gcup.ru/publ/programming/lua_dlja_vsej_semi_urok_5_rabota_so_strokami/8-1-0-513
-- https://gcup.ru/publ/programming/lua_tutorial_dlja_nachinajushhikh_chast_4/8-1-0-626


vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2b2b2b" })

local tab_snippet = {
	go={{'if err != nil {','  slog.Error(err.Error())','  return fmt.Errorf("ошибка %v", err)','}'},{'func main() {','  fmt.Println("")','}'},{'for k,v := range  {','}'}},
	html={{'<div id="app"></div>'},{"<button onclick={increment}></button>"},{"<li></li>"}},
	css={{'background-color: var(--color_box);'},{'font-weight: bold;'},{'text-decoration: none;'}},
	js={{"const elResult = document.querySelector('.result');"},{"btn.addEventListener('click', (event) => {","});"},{"console.log('');"}},
	ts={{"const elResult = document.querySelector('.result');"},{"btn.addEventListener('click', (event) => {","});"},{'const x: number = 0;'}},
	svelte={{'<script lang="ts">', '</script>','<main>','</main>','<style>','</style>'},{"import Counter from './lib/Counter.svelte'"},{"let count: number = $state(0)"}}
}

-- Функция для получения расширения файла
local function get_file_ext()
  -- Получаем имя файла текущего буфера
  local filename = vim.fn.expand("%:t")  -- %:t возвращает только имя файла (без пути)

  -- Находим расширение файла
  local extension = filename:match("^.+(%..+)$")

  -- Если расширение найдено, удаляем точку в начале
  if extension then
    return extension:sub(2)  -- Убираем точку (первый символ)
  else
    return nil  -- Если расширения нет
  end
end

-- печатает таблицу
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

local function put_snippet(select)
print_snippet(tab_snippet[get_file_ext()][select])
end

vim.keymap.set({'n','i'}, '<a-2>', function() put_snippet(1) end)
vim.keymap.set({'n','i'}, '<a-3>', function() put_snippet(2) end)
vim.keymap.set({'n','i'}, '<a-4>', function() put_snippet(3) end)


-- добовляет тэги к полям структуры на golang
local function gen_json_current_line()
	if get_file_ext() ~= "go" then
		return
	end

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
vim.keymap.set({'n','i'}, '<a-1>', function() gen_json_current_line() end)


-- автодополнение HTML тэгов
local function gen_snip_current_line()
	local ext = get_file_ext()
	if ext ~= "html" and ext ~= "svelte" then
		return
	end

	local line = vim.api.nvim_get_current_line()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)  -- Позиция курсора (строка, колонка)
	local row, col = cursor_pos[1], cursor_pos[2]

  -- Ищем позицию начала подстроки (до первого символа " ", ">", "," или начала строки)
  local start_pos = col
  while start_pos > 0 do
    local char = line:sub(start_pos, start_pos)
    if char == " " or char == "\t" or char == ">" or char == "," or char == "}" then
      break
    end
    start_pos = start_pos - 1
  end

	local teg = ">"
	local col_new = col
	local col_cur = col + 2		-- новое положение курсора
	if line:sub(col, col) == "." then
		col_new = col - 1
		teg = [[ class="">]]
		col_cur = col + 10
	end

  local substring = teg .. "</" .. line:sub(start_pos + 1, col_new) .. ">"

	-- Модифицируем строку: добавляем выделенный фрагмент дважды
  -- local new_line = line:sub(1, col) .. substring .. line:sub(col + 1)
  -- local new_line = line:sub(1, start_pos) .. "<" .. line:sub(start_pos + 1, col_new) .. substring .. line:sub(col + 1)
	vim.api.nvim_set_current_line(line:sub(1, start_pos) .. "<" .. line:sub(start_pos + 1, col_new) .. substring .. line:sub(col + 1))
	vim.api.nvim_win_set_cursor(0, { row, col_cur })
end

vim.keymap.set({'n','i'}, "<a-`>", function() gen_snip_current_line() end)

