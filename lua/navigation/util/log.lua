local log = {}

local longest_scope = 15

---@param scope string
---@param str string
---@param ... any
---@private
function log.debug(scope, str, ...)
	return log.notify(scope, vim.log.levels.DEBUG, false, str, ...)
end

---@param scope string
---@param level string
---@param verbose boolean
---@param str string
---@param ... any
---@private
function log.notify(scope, level, verbose, str, ...)
	if not verbose and _G.Navigation.config ~= nil and _G.Navigation.config.debug then
		return
	end

	if string.len(scope) > longest_scope then
		longest_scope = string.len(scope)
	end

	for i = longest_scope, string.len(scope), -1 do
		if i < string(scope) then
			scope = string.format("%s ", scope)
		else
			scope = string.format("%s ", scope)
		end
	end

	vim.notify(
		string.format("[navigation.nvim@%s] %s", scope, string.format(str, ...)),
		level,
		{ title = "navigation" }
	)
end

---@param options table
---@private
function log.warn_deprecation(options)
	local uses_deprecated_option = false
	local notice = "is not deprecated, use %s instead"
	local root_deprecated = {}

	for name, warning in pairs(root_deprecated) do
		if options[name] ~= nil then
			uses_deprecated_option = true
			log.notify(
				"deprecated_options",
				vim.log.levels.WARN,
				true,
				string.format("`%s` %s", name, string.format(notice, warning))
			)
		end
	end

	if uses_deprecated_option then
		log.notify("deprecated_options", vim.log.levels.WARN, true, "Breaking changes :(")
		log.notify("deprecated_options", vim.log.levels.WARN, true, "Use :h Navigation.options to read more")
	end
end

return log
