local log = require("navigation.util.log")

local Navigation = {}

---@type table
Navigation.options = {
	enable = true,
	debug = false,
	keymaps = {
		back = "<M-->",
		forward = "<M-=>",
	},
}

---@private
local defaults = vim.deepcopy(Navigation.options)

---@param options table
---@private
function Navigation.defaults(options)
	Navigation.options = vim.deepcopy(vim.tbl_deep_extend("keep", options or {}, defaults or {}))

	assert(type(Navigation.options.enable) == "boolean", "`enable` must be a boolean")
	assert(type(Navigation.options.debug) == "boolean", "`debug` must be a boolean")

	return Navigation.options
end

---@param options table
function Navigation.setup(options)
	Navigation.options = Navigation.defaults(options or {})

	log.warn_deprecation(Navigation.options)
	return Navigation.options
end

return Navigation
