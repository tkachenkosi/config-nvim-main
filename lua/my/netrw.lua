-- keymap("n", "<Leader>ex", "<cmd>Ex %:p:h<CR>") -- Open Netrw in the current file's directory
-- улучшенное создание файла во встроенном fikes manager
vim.api.nvim_create_autocmd("FileType", {
	pattern = "netrw",
	callback = function()
		-- local bs = { buffer = true, silent = true }
		-- local brs = { buffer = true, remap = true, silent = true }
		-- vim.keymap.set("n", "q", "<cmd>bd<CR>", bs) -- Close the current Netrw buffer
		-- vim.keymap.set("n", "<Tab>", "mf", brs)		-- Mark the file/directory to the mark lis
		-- vim.keymap.set("n", "<S-Tab>", "mF", brs) -- Unmark all the files/directories

		-- vim.keymap.set("n", "q", function()
		-- 	local bufnr = vim.api.nvim_get_current_buf()
		-- 	vim.api.nvim_win_close(0, false)
		-- 	vim.defer_fn(function()
		-- 		if vim.api.nvim_buf_is_valid(bufnr) then
		-- 			vim.api.nvim_buf_delete(bufnr, { force = true })
		-- 		end
		-- 	end, 50)
		-- end, bs)

		-- Improved file creation
		vim.keymap.set("n", "%", function()
			local dir = vim.b.netrw_curdir or vim.fn.expand("%:p:h")
			vim.ui.input({ prompt = "Enter filename: " }, function(input)
				if input and input ~= "" then
					local filepath = dir .. "/" .. input
					vim.cmd("!touch " .. vim.fn.shellescape(filepath))
					vim.api.nvim_feedkeys("<C-l>", "n", false) -- обновление списка файлов
				end
			end)
		end, { buffer = true, silent = true })
	end,
})


-- SmartNetrw открытие и закрытие files explorer
local function SmartNetrw()
  local netrw_bufs = {}

	-- Собираем все активные буферы netrw
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(bufnr) then
			local ft = vim.api.nvim_get_option_value('filetype', { buf = bufnr })
			if ft == 'netrw' then
				table.insert(netrw_bufs, bufnr)
			end
		end
	end

	if #netrw_bufs > 0 then
		-- Если буферы netrw есть — закрываем их все
		for _, bufnr in ipairs(netrw_bufs) do
				vim.api.nvim_buf_delete(bufnr, { force = true })
		end
		if vim.api.nvim_get_current_buf() == netrw_bufs[1] then
				vim.cmd("close")   -- если текущее окно было netrw
		end
	else
		-- Если буферов netrw нет — открываем новый
		vim.cmd("25vs +Explore")
	end
end

vim.keymap.set('n', '<leader>e', SmartNetrw, { desc = 'Toggle netrw file explorer' })

