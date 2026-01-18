local main = require("navigation.main")
local config = require("navigation.config")

local Navigation = {}

function Navigation.toggle()
	if _G.Navigation.config == nil then
		_G.Navigation.config = config.options
	end

	main.toggle("public_api_toggle")
end

function Navigation.enable(scope)
	if _G.Navigation.config == nil then
		_G.Navigation.config = config.options
	end

	main.toggle(scope or "public_api_emable")
end

function Navigation.disable()
	main.toggle("public_api_disable")
end

function Navigation.setup(opts)
	_G.Navigation.config = config.setup(opts)
	if _G.Navigation.config.enable then
		main.enable("setup")
	else
		main.disable("setup")
	end
end

_G.Navigation = Navigation

return _G.Navigation
