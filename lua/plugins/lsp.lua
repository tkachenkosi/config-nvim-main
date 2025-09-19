return {
  {
    "neovim/nvim-lspconfig",
    config = function()

			-- capabilities для nvim-cmp
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if ok then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
      end

      -- Настройка lua_ls с кастомными settings
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" }, -- чтобы не ругался на глобальную vim
            },
          },
        },
      })

      -- Остальные LSP с другим синтаксисом настройки
      -- vim.lsp.config("gopls", { capabilities = capabilities })
      -- vim.lsp.config("ts_ls", { capabilities = capabilities })

      -- vim.lsp.enable({
        -- "lua_ls",
        -- "gopls",
        -- "ts_ls",
        -- "html",
        -- "cssls",
        -- "svelte",
      -- })

      -- список серверов
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
            },
          },
        },
        gopls = {},
        ts_ls = {},
        -- clangd = {},
        html = {},
        cssls = {},
        svelte = {},
        -- rust_analyzer = {},
      }

      -- регистрируем все сервера
      for name, opts in pairs(servers) do
        opts.capabilities = capabilities
        vim.lsp.config(name, opts)
      end

      -- активируем их
      vim.lsp.enable(vim.tbl_keys(servers))


      -- Общие keymaps при LspAttach
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("n", "<Leader>D", vim.lsp.buf.type_definition, opts)
          vim.keymap.set("n", "qr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "<Leader>lr", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename Symbol" })
          vim.keymap.set({ "n", "v" }, "<Leader>la", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<Leader>lf", function()
            vim.lsp.buf.format({ async = true })
          end, opts)
        end,
      })
    end,
  },
}

