vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
})

-- установка парсеров. Lazy install (не тормозит старт, не блокирует UI)
vim.schedule(function()
  require('nvim-treesitter').install({
    "c","cpp","lua","typescript","javascript","query","rust","go",
    "css","html","json","make","sql","toml","bash","markdown",
    "dockerfile","svelte","yaml","tsx","vim"
  })
end)

-- ===== настройки =====
local MAX_VIEW_LINES = 200      -- сколько строк можно держать подсвеченными
local SCROLL_COOLDOWN = 120     -- ms, пауза после скролла
local BIGFILE_LINES = 5000

-- ===== состояние =====
local timers = {}
local active = {}

local function is_big(buf)
  return vim.api.nvim_buf_line_count(buf) > BIGFILE_LINES
end

local function view_line_count(win)
  local top = vim.fn.line("w0", win)
  local bot = vim.fn.line("w$", win)
  return bot - top
end

local function ts_on(buf)
  if active[buf] then return end
  if is_big(buf) then return end

  local ok = pcall(vim.treesitter.start, buf)
  if ok then active[buf] = true end
end

local function ts_off(buf)
  if not active[buf] then return end
  vim.treesitter.stop(buf)
  active[buf] = nil
end



local group = vim.api.nvim_create_augroup("TS_partial", { clear = true })

-- старт (лениво)
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  callback = function(ev)
    vim.defer_fn(function()
      ts_on(ev.buf)
    end, 30)
  end,
})



vim.api.nvim_create_autocmd({ "WinScrolled", "CursorMoved" }, {
  group = group,
  callback = function(ev)
    local buf = ev.buf
    local win = vim.api.nvim_get_current_win()

    if is_big(buf) then
      ts_off(buf)
      return
    end

    local visible = view_line_count(win)

    -- если слишком много строк → отключаем
    if visible > MAX_VIEW_LINES then
      ts_off(buf)
      return
    end

    -- debounce: включаем обратно после паузы
    if timers[buf] then
      timers[buf]:stop()
      timers[buf]:close()
    end

    local t = vim.uv.new_timer()
    timers[buf] = t

    t:start(SCROLL_COOLDOWN, 0, vim.schedule_wrap(function()
      ts_on(buf)
      t:close()
      timers[buf] = nil
    end))
  end,
})


