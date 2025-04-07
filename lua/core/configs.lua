vim.wo.number = true
-- vim.wo.relativenumber = true
vim.opt.mouse = "a"
vim.opt.mousefocus = true
vim.opt.clipboard = "unnamedplus"

vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.smartindent = true  -- что то для отступов в новой строке
vim.opt.autoindent = true		-- копирует отступы с текущей строки при добавлении новой
vim.opt.breakindent = true	-- позволяет сохранять отступы виртуальных строк

vim.opt.encoding="utf-8"
vim.opt.fileformat="unix"

vim.opt.scrolloff = 3
vim.opt.wrap = false
vim.opt.termguicolors = true
vim.opt.background = "dark" -- or "light" for light mode

vim.opt.updatetime = 25000
vim.opt.timeoutlen = 1600
vim.opt.undolevels = 200
vim.opt.history = 300

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.wo.foldmethod = 'marker'

-- настройки для встоенного Exploer
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 4

-- Не понятные настройки
-- opt.cursorline = true
vim.wo.signcolumn = 'yes'
-- vim.opt.hlsearch = true
-- vim.opt.hidden = true

-- vim.api.nvim_set_hl(0, "CursorLine", { bg = "#112233" })
vim.api.nvim_win_set_option(0, "cursorline", true) -- Включаем подсветку текущей строки

-- vim.api.statusline = %r%t%{(&mod?'*':'')}
-- set statusline=%r%t%{(&mod?'*':'')}

vim.opt.laststatus = 2
vim.opt.showmode = false
vim.opt.shortmess:append("sIc")


local config = {
  colors = {
    mode = { bg = '#80a0ff', bold = true },
    file_name = { bold = true },
    modified = { bold = true},
    line_no = {},
    -- col_no = {},
    -- total_lines = {bg = '#ebdbb2', fg = '#504945'}
  }
}

local function setup_highlights()
  for group, colors in pairs(config.colors) do
    vim.api.nvim_set_hl(0, 'Status'..group:gsub("_", ""), colors)
  end
end

local function status_line()
  local mode = "%#Statusmode#%-5{%v:lua.string.upper(v:lua.vim.fn.mode())%}%*"
  local file_name = "%#Statusfilename#%-.24t%*"
  local modified = "%#Statusmodified# %-M%*"
  local right_align = "%="
  local line_no = "%#Statuslineno#%6.6l:%*"
  local line_cl = "%#Statuslineno#%-3.3v%*"
  local line_all = "%#Statuslineno#%6.6L%*"

  return table.concat({
    mode, file_name, modified, right_align, line_no, line_cl, line_all
  }, "")
end

setup_highlights()
vim.opt.statusline = status_line()

