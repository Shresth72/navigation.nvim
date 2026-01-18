local log = require("navigation.util.log")
local state = require("navigation.state")
local cursor = require("navigation.cursor")

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

function main.set_keymaps()
	local keymaps = _G.Navigation.config.keymaps
	if not keymaps then
		return
	end

	if keymaps.back then
		vim.keymap.set("n", keymaps.back, main.back, { desc = "Navigation Back" })
	end

	if keymaps.forward then
		vim.keymap.set("n", keymaps.forward, main.forward, { desc = "Navigation Forward" })
	end
end

---@param scope string
---@private
function main.enable(scope)
	if state.get_enabled(state) then
		log.debug(scope, "navigation.nvim is already enabled")
		return
	end

	main.set_keymaps()
	main.create_commands()

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

---@private
function main.create_commands()
	vim.api.nvim_create_autocmd("CursorMoved", {
		callback = main.record,
	})
end

-- Expose cursor stack functions
function main.record()
	cursor.record()
end

function main.back()
	cursor.back()
end

function main.forward()
	cursor.forward()
end

return main
