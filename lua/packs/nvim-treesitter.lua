vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
})

-- Lazy install parsers (не тормозит старт, не блокирует UI)
vim.schedule(function()
  require('nvim-treesitter').install({
    "c","cpp","lua","typescript","javascript","query","rust","go",
    "css","html","json","make","sql","toml","bash","markdown",
    "dockerfile","svelte","yaml","tsx","vim"
  })
end)

-- -- disable treesitter for large files
-- local MAX_LINES = 5000
--
-- -- Start treesitter. 
-- vim.api.nvim_create_autocmd('FileType', {
--   callback = function(ev)
-- 		-- checking the file size
-- 		if vim.api.nvim_buf_line_count(ev.buf) > MAX_LINES then
-- 			-- возврат подсветки на regex
-- 			vim.bo[ev.buf].syntax = "on"
-- 			return
-- 		end
--
-- 		-- не дергать start() повторно
--     if not vim.treesitter.highlighter.active[ev.buf] then
--       pcall(vim.treesitter.start, ev.buf)
--     end
--   end,
-- })
--
