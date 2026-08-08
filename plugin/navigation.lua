if _G.NavigationLoaded then
	return
end

_G.NavigationLoaded = true

require("navigation").setup()

vim.api.nvim_create_user_command("Navigation", function()
	require("navigation").toggle()
end, {})
