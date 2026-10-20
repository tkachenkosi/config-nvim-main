local win = nil
local buf = nil

local function toggle_term()
  -- 1. Если окно уже видимо — свернуть и выйти
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_hide(win)
    win = nil
    return
  end

  -- 2. Проверить, что сохранённый буфер валиден И его процесс жив
  if buf and vim.api.nvim_buf_is_valid(buf) then
    local ok, job = pcall(vim.fn.jobpid, vim.b[buf].terminal_job_id or 0)
    if not ok or job == 0 then
      buf = nil  -- процесс умер или job_id недоступен — пересоздать
    end
  end

  -- 3. Создать новый терминал, если буфера нет / он мёртв
  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    vim.cmd("below split | terminal")
    buf = vim.api.nvim_get_current_buf()
    win = vim.api.nvim_get_current_win()
    vim.bo[buf].bufhidden = "hide"
  else
    -- 4. Показать существующий живой терминал
    vim.cmd("below split")
    win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win, buf)
    vim.cmd("startinsert")
  end
end

vim.keymap.set("n", "<C-t>", toggle_term, { desc = "Toggle terminal" })
vim.keymap.set("t", "<C-t>", toggle_term, { desc = "Toggle terminal" })
