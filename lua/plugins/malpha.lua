return {
	"tkachenkosi/malpha.nvim",
	config = function()
			require("malpha").setup({
				count_recent = 25,
			})
			require("malpha").enable_autostart()
	end,
	event = "VimEnter",
}

