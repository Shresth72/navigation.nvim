local log = require("navigation.util.log")
local state = require("navigation.state")

-- internal methods
local main = {}

---@param scope string
---@private
function main.toggle(scope)
	if state.get_enabled(state) then
		log.debug(scope, "navigation.nvim is now disabled!")
		return main.disable(scope)
	end

	log.debug(scope, "navigation.nvim is now enabled")
	main.enable(scope)
end

---@param scope string
---@private
function main.enable(scope)
	if state.get_enabled(state) then
		log.debug(scope, "navigation.nvim is already enabled")
		return
	end

	state.set_enabled(state)
	state.save(state)
end

---@param scope string
---@private
function main.disable(scope)
	if not state.get_enabled(state) then
		log.debug(scope, "navigation.nvim is already disabled")
		return
	end

	state.set_disabled(state)
	state.save(state)
end

return main
