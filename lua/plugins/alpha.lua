return {
    "goolord/alpha-nvim",
    dependencies = {"kyazdani42/nvim-web-devicons", opt = true},
    config = function ()
        local startify = require("alpha.themes.startify")
        require("alpha").setup(startify.config)
        startify.section.header.val = "© Config by Tkachenkosi 2024"
        startify.section.bottom_buttons.val = {
          startify.button("s", "session", ":so .session<CR>"),
          startify.button("c", "config", ":e ~/.config/nvim/lua/core/configs.lua<CR>"),
          startify.button("k", "keymaps", ":e ~/.config/nvim/lua/core/mappings.lua<CR>"),
          -- startify.button("p", "plugin", ":e ~/.config/nvim/lua/plugins/lsp.lua<CR>"),
          startify.button("q", "quit", ":qa<CR>"),
        }
    end
};
