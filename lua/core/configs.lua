vim.wo.number = true
-- vim.wo.relativenumber = true
vim.opt.mouse = "a"
vim.opt.mousefocus = true
vim.opt.clipboard = "unnamedplus"

vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.smartindent = true  -- что то для отступов в новой строке

vim.opt.encoding="utf-8"
vim.opt.fileformat="unix"

vim.opt.scrolloff = 5
vim.opt.wrap = false
vim.opt.termguicolors = true
vim.opt.background = "dark" -- or "light" for light mode
vim.opt.breakindent = true

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
