
local function _buff11()
  vim.api.nvim_set_current_line('if err!=nil {slog.Error(err.Error()); os.Exit(1)}')
end


vim.keymap.set('n', '<a-1>', function() _buff11() end)
