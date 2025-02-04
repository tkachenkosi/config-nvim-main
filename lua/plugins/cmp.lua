return {
  {'hrsh7th/cmp-nvim-lsp'},
  {'hrsh7th/cmp-buffer'},
  {'hrsh7th/cmp-path'},
  {'hrsh7th/vim-vsnip'},
  {'hrsh7th/cmp-vsnip'},
  {'hrsh7th/cmp-cmdline'},
  {
    'hrsh7th/nvim-cmp',
    config = function()
      local cmp = require("cmp")
      cmp.setup({

        snippet = {
              -- REQUIRED - you must specify a snippet engine
              expand = function(args)
                vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
                -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
              end,
            },
            window = {
              -- completion = cmp.config.window.bordered(),
              -- documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
              ['<C-b>'] = cmp.mapping.scroll_docs(-4),
              ['<C-f>'] = cmp.mapping.scroll_docs(4),
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<C-e>'] = cmp.mapping.abort(),
              ['<Tab>'] = cmp.mapping.abort(),
              ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
              -- ['<Up>'] = cmp.mapping.select_prev_item({behavior = 'select'}),     -- просто перемещаемся по списку (эти клавиши работают и так)
              -- ['<Down>'] = cmp.mapping.select_next_item({behavior = 'select'}),
              -- ['<C-n>'] = cmp.mapping(function(falback)
              ['<c-Tab>'] = cmp.mapping(function(falback)
                if cmp.visible() then
                  cmp.select_next_item({behavior = 'insert'})   -- перемещаемся по списку и делаем замену в редактори в позиции курсора при перемещении
                else
                  -- cmp.complete()
									falback()
                end
              end, {"i", "s"}),
              -- ['<C-p>'] = cmp.mapping(function(falback)
              ['<s-Tab>'] = cmp.mapping(function(falback)
                if cmp.visible() then
                  cmp.select_prev_item({behavior = 'insert'})
                else
                  -- cmp.complete()
									falback()
                end
              end, {"i", "s"}),
            }),
            sources = cmp.config.sources({
              { name = 'nvim_lsp' },
              { name = 'vsnip' }, -- For vsnip users.
              -- { name = 'luasnip' }, -- For luasnip users.
              -- { name = 'ultisnips' }, -- For ultisnips users.
              -- { name = 'snippy' }, -- For snippy users.
            }, {
              { name = 'buffer' },
            })

      })
    end
  }
}

-- примеры и обсуждения настроек. Решил проблему с работы модуля в lua
-- https://github.com/hrsh7th/vim-vsnip/issues/219
