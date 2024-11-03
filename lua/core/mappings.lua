-- Buffers
vim.api.nvim_set_keymap("n", "<leader>q", "<cmd>qa<CR>", {})
vim.api.nvim_set_keymap("n", "<leader>w", "<cmd>w<CR>", {})
vim.api.nvim_set_keymap('n', '<F2>', '<cmd>w<CR>', {})
vim.api.nvim_set_keymap('i', '<F2>', '<Esc><cmd>w<CR>', {})
-- vim.keymap.set("i", "jj", "<Esc>")

-- закоментировать строку/ Коментарий блока - <leader>gc
-- vim.keymap.set('n', '<F3>', "gcc", {})
vim.api.nvim_set_keymap('n', '<F3>', "gccj", {})
vim.api.nvim_set_keymap('i', '<F3>', "<Esc>gcca", {})

-- выделяем и копируем слово (F4 может не нужно это только выделение)
vim.api.nvim_set_keymap('n', '<F5>', 'viwy', {})
-- vim.keymap.set('i', '<F5>', '<Esc>viwy', {})

-- копирует и всавляем из системного буфера (пока только вставляет, эта поперация нужна чаще)
vim.api.nvim_set_keymap('n', '<F6>', '"+p', {})
vim.api.nvim_set_keymap('i', '<F6>', '<Esc>"+pa', {})
vim.api.nvim_set_keymap('v', '<F6>', '"+y', {})     -- копирует выделенный фрагмент в системный буфер в режиме выделения

-- выделяет и тутже заменяет слово
vim.api.nvim_set_keymap('n', '<F8>', 'viw"0p', {})
vim.api.nvim_set_keymap('i', '<F8>', '<Esc>viwp', {})

-- быстрый поиск (выделение) текста. Так же есть команада * - движение по n вперед, # - назад
vim.keymap.set('n', '<F7>', '*', {})
vim.keymap.set('i', '<F7>', '<Esc>*', {})

-- сдублировать строку
vim.api.nvim_set_keymap('n', [[<c-l>]], [[yyp]], {})
vim.api.nvim_set_keymap('i', [[<c-l>]], [[<Esc>yypa]], {})

-- сдублировать и закоментировать первую строку
vim.api.nvim_set_keymap('n', [[<a-l>]], [[yypkgccj]], {})
vim.api.nvim_set_keymap('i', [[<a-l>]], [[<Esc>yypkgccja]], {})

vim.api.nvim_set_keymap('n', '<a-y>', [["tyy]], {})          -- скопировать всю строку в регистр "t (temp)
vim.api.nvim_set_keymap('v', '<a-y>', [["ty]], {})           -- скопировать выделенный блок в регистр "t
vim.api.nvim_set_keymap('i', '<a-y>', [[<Esc>"tyya]], {})    -- скопировать всю строку в режиме редактирования

-- дополнительное кнопка для вставки из буфера не зависищая от режима и перехода в режим редактирования курсор в начало
vim.api.nvim_set_keymap('n', '<a-p>', [["tpa]], {})          -- вставляют из регистра "t
vim.api.nvim_set_keymap('v', '<a-p>', [["tp]], {})           -- вставляют из регистра "t
vim.api.nvim_set_keymap('i', '<a-p>', [[<Esc>"tpa]], {})

-- Windows
-- vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
-- vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
-- vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
-- vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")
-- переходит в левое окно (Exploer) и его закрывает.
-- vim.keymap.set("n", "<a-h>", ":wincmd h<CR>:wincmd q<CR>")
vim.api.nvim_set_keymap("n", "<leader>x", ":wincmd h<CR>:wincmd q<CR>", {})

vim.api.nvim_set_keymap('n', '<c-s>', '<cmd>set relativenumber!<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>/', '<cmd>noh<CR>', {})


-- переключиться на предыдущий буфер
vim.api.nvim_set_keymap('n', '<F10>', '<c-6>', {})
vim.api.nvim_set_keymap('i', '<F10>', '<Esc><c-6>', {})
-- выдиляет весь текст
vim.api.nvim_set_keymap('n', '<Leader>sa', 'ggVG<c-$>', {})
-- дополнительная команда входа в командный режим
vim.api.nvim_set_keymap("n", ";", ":", {desc = "CMD enter comand mode"})

-- встроенный Exploer (открываем слева окно в 30 колонок)
-- keymap('n', '<leader><F3>', '<Esc>:Explore<CR>', {})
vim.api.nvim_set_keymap("n", "<leader><F3>", "<cmd>30vs +Exp<CR>", {})

-- vim.keymap.set("n", "//", ":vsplit<CR>")
-- vim.keymap.set("n", "||", ":split<CR>")

-- Tab
vim.api.nvim_set_keymap("n", "<Tab>", "<c-6>", {})
vim.api.nvim_set_keymap('n', '<S-Tab>', '<cmd>bprevious<CR>', {})

-- цветовые темы оформления
-- vim.keymap.set('n', '<leader>1', [[<cmd>colorscheme onedark<CR>]])
vim.keymap.set('n', '<leader>2', function() require('onedark').load(); end, {})
vim.keymap.set('n', '<leader>4', function() require('gruvboxmy').load(); end, {})
-- vim.keymap.set('n', '<leader>4', [[<cmd>colorscheme gruvboxmy<CR>]])

-- отмена в привычном сочетании
vim.api.nvim_set_keymap('n', '<c-z>', "<cmd>undo<CR>", {})
vim.api.nvim_set_keymap('i', '<c-z>', "<Esc><cmd>undo<CR>", {})
-- заблокируем стандартную отмену, что бы не путаться
-- keymap('n', 'u', "<Nop>", {})
-- навесим на u снятие выделения
vim.api.nvim_set_keymap('n', 'u', '<cmd>noh<CR>', {})

vim.keymap.set('n', '<leader>й', "<cmd>qa<CR>")
vim.keymap.set('n', 'щ', 'o')
vim.keymap.set('n', 'ш', 'i')
vim.keymap.set('n', 'ф', 'a')
vim.keymap.set('n', 'Ж', ':')
vim.keymap.set('n', 'М', 'V')
vim.keymap.set('n', 'м', 'v')
vim.keymap.set('n', 'г', 'u')
vim.keymap.set('n', 'н', 'y')
vim.keymap.set('v', 'н', 'y')
vim.keymap.set('o', 'н', 'y')
vim.keymap.set('n', 'з', 'p')
vim.keymap.set('v', 'з', 'p')
vim.keymap.set('n', 'в', 'd')
vim.keymap.set('v', 'в', 'd')
vim.keymap.set('o', 'в', 'd')
