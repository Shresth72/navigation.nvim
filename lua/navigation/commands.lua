local M = {}

---@param main table
function M.setup(main)
	local commands = {
		{
			name = "NavigationToggle",
			callback = function()
				main.toggle("command_toggle")
			end,
			opts = {
				desc = "Toggle navigation.nvim",
			},
		},
		{
			name = "NavigationEnable",
			callback = function()
				main.enable("command_enable")
			end,
			opts = {
				desc = "Enable navigation.nvim",
			},
		},
		{
			name = "NavigationDisable",
			callback = function()
				main.disable("command_disable")
			end,
			opts = {
				desc = "Disable navigation.nvim",
			},
		},
		{
			name = "NavigationBack",
			callback = function()
				main.back()
			end,
			opts = {
				desc = "Navigate back",
			},
		},
		{
			name = "NavigationForward",
			callback = function()
				main.forward()
			end,
			opts = {
				desc = "Navigate forward",
			},
		},
		{
			name = "NavigationDefinition",
			callback = function()
				main.goToDefinition()
			end,
			opts = {
				desc = "Go to definition with navigation record",
			},
		},
		{
			name = "NavigationReferences",
			callback = function()
				main.goToReferences()
			end,
			opts = {
				desc = "Go to references with navigation record",
			},
		},
		{
			name = "NavigationLine",
			callback = function(opts)
				main.goToLineNumber(opts.args)
			end,
			opts = {
				desc = "Navigate to line with navigation record",
				nargs = 1,
			},
		},
	}

	for _, command in ipairs(commands) do
		if vim.fn.exists(":" .. command.name) == 2 then
			vim.api.nvim_del_user_command(command.name)
		end

		vim.api.nvim_create_user_command(command.name, command.callback, command.opts)
	end
end

return M
