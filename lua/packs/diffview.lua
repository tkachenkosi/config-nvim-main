vim.pack.add({
	{
		src = "https://github.com/dlyongemallo/diffview-plus.nvim.git",
		name = "diffview-plus.nvim",
		version = "main",
	},
})

require("diffview").setup({
		enhanced_diff_hl = true,
		use_icons = true,
		view = {
				default = { layout = "diff2_horizontal" },
				merge_tool = { layout = "diff3_horizontal" },
		},
		file_panel = {
				listing_style = "tree",
				win_config = { position = "left", width = 35 },
		},

})
    


