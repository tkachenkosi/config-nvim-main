return {
	-- {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
		'nvim-lua/plenary.nvim',
		-- 'nvim-telescope/telescope-fzf-native.nvim'
	},
  config = function()
    require("telescope").setup({
      defaults = {
        -- исключим эти файлы из поиска
        file_ignore_patterns = {"^node_modules/", "^dist/", "^tmp/", "bootstrap%.", "gitignore",
					"^git/", "^github/", "%.yaml", "package%pjson", "package%plock%pjson", "%.jpg", "%.svg",
					"%.png", "%.woff2", "%.pdf", "%.log", "%.gz", "%.zip", "%.ses", "%.mod", "%.sum"
			},
        mappings = {
          i = {
            -- ['<c-u>'] = false,
            -- ['<c-d>'] = false,
            ["<Esc>"] = require('telescope.actions').close,
            ["<C-j>"] = require('telescope.actions').move_selection_next,
            ["<C-k>"] = require('telescope.actions').move_selection_previous,
          },
        },
      },
			extensions = {
				fzf = {
          fuzzy = true, -- Включить нечёткий поиск
          override_generic_sorter = true, -- Переопределить сортировку
          override_file_sorter = true, -- Переопределить сортировку файлов
          case_mode = "smart_case", -- Умный регистр
        },
			}
    })

    -- Загрузка расширений
		-- require("telescope").load_extension("fzf")
    -- require("telescope").load_extension("git")
    -- require("telescope").load_extension("lsp")

    local builtin = require('telescope.builtin')
    local themes = require('telescope.themes')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
    vim.keymap.set('n', '<leader>fm', function() builtin.marks(); end)
    vim.keymap.set({'n', 'i'}, '<F12>', function() builtin.buffers(themes.get_dropdown({previewer=false})); end)
    vim.keymap.set('n', '<C-Tab>', function() builtin.buffers(themes.get_dropdown({previewer=false})); end)
  end
    -- },
    -- {
    --     'nvim-telescope/telescope-fzf-native.nvim', -- Расширение для fzf
    --     build = 'make', -- Сборка плагина
    -- },
}
