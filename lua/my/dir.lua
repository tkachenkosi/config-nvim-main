-- Настройка dir.lua

-- делаем так что бы после выбора файла в dir.lua буфер закрывался
vim.api.nvim_create_autocmd("FileType", {
  pattern = "directory",				-- сработает только для dir.lua
  callback = function()
    vim.bo.bufhidden = "delete"	-- буфер dir.lua удаляется, как только становится скрытым
		vim.bo.buflisted = false		-- скрыть из :ls и большинства пикеров
  end,
})


local ns = vim.api.nvim_create_namespace('my.dir.classify')

-- Список расширений программных файлов (ключи в нижнем регистре)
local program_exts = {
  go = true, js = true, ts = true, html = true, css = true,
	py = true, rs = true, lua = true, sh = true, bash = true,
  c = true, h = true, cpp = true, hpp = true, sql = true,
}

-- Цвета: каталоги, скрытые, программные файлы
vim.api.nvim_set_hl(0, "DirListing", { fg = "#9fbddf", default = true })
vim.api.nvim_set_hl(0, "DirHidden",  { fg = "#808080", default = true })
vim.api.nvim_set_hl(0, "DirProgram", { fg = "#d68082", default = true })

-- Определяем, какую группу подсветки применить к имени
local function classify(name)
  if name == '' then return nil end

  -- 1. Скрытые файлы и каталоги: .git, .env, .config/
  if name:sub(1, 1) == '.' then
    return 'DirHidden'
  end

  -- 2. Каталоги (dir.lua помечает их суффиксом "/")
  if name:sub(-1) == '/' then
    return 'DirListing'
  end

  -- 3. Программные файлы по расширению
  local ext = name:match('%.([^%.]+)$')
  if ext and program_exts[ext:lower()] then
    return 'DirProgram'
  end

  return nil
end

-- раскрашивает каждую строчку dir.lua
vim.api.nvim_set_decoration_provider(ns, {
  on_win = function(_, _, buf)
    return vim.bo[buf].filetype == 'directory'
  end,
  on_range = function(_, _, buf, row)
    local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, true)[1]
    if not line or line == '' then
      return true
    end

    local hl = classify(line)
    if hl then
      vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
        end_col = #line,
        hl_group = hl,
        ephemeral = true,
        priority = 200,
      })
    end

    return true
  end,
})

-- получить путь файла в текущем буфере
local function getCurrPath()
	-- Получаем полный путь к файлу в текущем буфере
	local file_path = vim.api.nvim_buf_get_name(0)
	-- Получаем директорию файла
	return file_path and vim.fs.dirname(file_path)
	-- Выводим результат
	-- print("Директория файла:", dir_path)
end

-- открытие dir.lua из редактора
vim.keymap.set("n", "<leader>kf", function()
	-- vim.cmd("edit " .. getCurrPath())
	vim.api.nvim_cmd({ cmd = 'edit', args = { getCurrPath() } }, {})
end, { noremap = true, silent = true })

