local log = require("navigation.util.log")

local state = { enabled = false }

---@private
function state:init()
	self.enabled = false
end

---@private
function state:save()
	log.debug("state.save", "Saving state globally to _G.Navigation.state")

	_G.Navigation.state = self
end

---@private
function state:set_enabled()
	self.enabled = true
end

---@private
function state:set_disabled()
	self.enabled = false
end

---@return boolean
---@private
function state:get_enabled()
	return self.enabled
end

return state
