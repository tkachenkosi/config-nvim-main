-- читает слово под курсором, определяет расширение файла 
-- поиск основан на запуске пользовательской команды (in cmd.lua) Rg <ext_file> <current_word>
local function QuickfixCurrWord()
    local current_mode = vim.api.nvim_get_mode().mode
    local current_word

    if current_mode == 'n' then
        current_word = vim.fn.expand('<cword>')
    elseif current_mode == 'v' or current_mode == 'V' or current_mode == '\22' then -- \22 = Ctrl-V
			-- это для поиска выделенного фрагмента, а не одного слова
			-- Сохраняем выделение в регистр "
			vim.cmd('noautocmd normal! "xy')
			-- Получаем выделенный текст из регистра x
			-- Убираем последний символ если это перевод строки (в визуальном режиме часто добавляется)
			current_word = vim.fn.getreg('x'):gsub('\n$', '')
    else
        vim.notify("Не поддерживаемый режим", vim.log.levels.WARN)
        return
    end

    if current_word == '' then
        vim.notify("Ничего не выделено", vim.log.levels.WARN)
        return
    end

    local ext_file = vim.fn.expand('%:e')
    if ext_file == '' then
        vim.notify("Файл без расширения", vim.log.levels.WARN)
        return
    end

    -- Используем vim.system (асинхронно)
    local args = { "rg", "--vimgrep", "--type", ext_file, current_word }

		vim.system(args, { text = true }, function(out)
			vim.schedule(function()
				if out.code ~= 0 or out.stdout == "" then
					vim.notify("Ничего не найдено или ошибка", vim.log.levels.INFO)
					return
				end
				local lines = vim.split(out.stdout, "\n")
				vim.fn.setqflist({}, ' ', {
					title = string.format('Rg %s %s (%d)', ext_file, current_word, #lines),
					lines = lines
				})
				vim.cmd("copen")
			end)
		end)

end

vim.keymap.set({'n','v'}, '<leader><F7>', QuickfixCurrWord, {desc = 'Quickfix current word'})


-- Создаём свою команду :Rg для Quickfix (:vimgrep / :grep)
-- на основе консольной утилиты rg (--vimgrep имеет режим вставания)
-- example:
-- :Rg go import 
-- :Rg js import
-- :Rg js -w app - поиск в файлах *.js целого слова "app"
-- :Rg import - поиск "import" во всех файлах которые разрешены в конфиге rj и .ignoge
-- ]q и [q - перемещение по результатам поиска
vim.api.nvim_create_user_command("Rg", function(opts)
  local args = opts.args
  local file_type = nil

  -- Парсим аргументы: если первый аргумент это известный тип
  local first_arg = vim.split(args, " ")[1]
  local file_types = {
    go = "go", css = "css", js = "js", ts = "ts",
    svelte = "svelte", html = "html", lua = "lua", rs = "rust"
  }

  if file_types[first_arg] then
    file_type = file_types[first_arg]
    -- Убираем тип из аргументов поиска
    args = args:gsub("^"..first_arg.."%s+", "")
  end

  -- local cmd = "rg --vimgrep --smart-case --hidden --glob '!testdata/**' --glob '!node_modules/**' --glob '!dist/**'"
  -- local cmd = "rg --vimgrep --smart-case --no-hidden --glob '!testdata/*' --glob '!node_modules/*' --glob '!dist/*'"
  local cmd = "rg --vimgrep"
  if file_type then
    cmd = cmd.." --type "..file_type
  end
  cmd = cmd.." "..args

  local result = vim.fn.systemlist(cmd)
  -- local title = file_type and ('Rg '..file_type..' '..args) or ('Rg '..args)
  local title = file_type and string.format('(%d) Rg %s %s', #result, file_type, args) or string.format('(%d) Rg %s', #result, args)

  vim.fn.setqflist({}, ' ', { title = title, lines = result })
  vim.cmd("copen")
end, { nargs = "+" })


-- привязка keymap для окна quickfix
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  callback = function()
    -- vim.keymap.set('n', '<C-q>', ':cclose<CR>', { buffer = true, nowait = true })
    -- Можно добавить и другие удобные маппинги для quickfix окна
    vim.keymap.set('n', '<Esc>', ':cclose<CR>', { buffer = true, nowait = true })
    vim.keymap.set('n', 'q', ':cclose<CR>', { buffer = true, nowait = true })
  end
})

