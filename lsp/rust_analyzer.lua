return {
    name = "rust-analyzer",
	-- cmd = { "rust-analyzer" },
    cmd = { os.getenv("HOME") .. "/.local/share/nvim/mason/bin/rust-analyzer" },
    root_markers = { ".git", ".session" },
    filetypes = { "rust" },
    settings = {
        ["rust-analyzer"] = {
            cargo = { 
                allFeatures = true 
            },
            checkOnSave = true, -- или false, если не хотите проверку при сохранении
            check = {
                command = "clippy", -- тип проверки
                extraArgs = { "--", "-W", "clippy::pedantic" } -- дополнительные аргументы
            },
        },
    },
}
