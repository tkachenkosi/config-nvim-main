return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {"kyazdani42/nvim-web-devicons", opt = true},
    -- dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()

      local custom_gruvbox = require('lualine.themes.gruvbox-material')
      custom_gruvbox.normal.c.fg = '#80a0ff'    -- цвет названия файла в строке статуса (лунно голубой)
      -- custom_gruvbox.normal.c.bg = '#112233'    -- цвет фона строки статуса (черно синий) #002288
      custom_gruvbox.normal.c.bg = '#152b40'    -- цвет фона строки статуса (черно синий) #002288

      require("lualine").setup({
        options = {
          icons_enabled = false,
          -- theme = 'gruvbox-material',
          theme = custom_gruvbox,
          component_separators = { left = '', right = ''},
          section_separators = { left = '', right = ''},
          disabled_filetypes = {},
          always_divide_middle = true,
          globalstatus = true,
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = {'filename'},
          -- lualine_x = {'encoding'},
          lualine_x = {},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {'filename'},
          lualine_x = {'location'},
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        extensions = {}
      })
    end
  }
}
