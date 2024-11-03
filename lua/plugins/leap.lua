return {
  {
    "ggandor/leap.nvim",
    lazy = false,
    config = function() 
      require("leap").add_default_mappings(true)
    end
  }
}
-- перемещение в тексте по ключевым буквам 
-- вызывается s + <кл.буквs>
