---@class CursorPos
---@field buf integer
---@field cursor integer[]  -- {row, col}

---@class CursorStackModule
---@field stack CursorPos[]
---@field index integer|nil
---@field max_size integer
---@field pending boolean
local M = {}

---@type CursorPos[]
M.stack = {}

---@type integer|nil
M.index = nil

---@type integer
M.max_size = 100

---@type boolean
M.pending = false

local function get_pos()
	---@type CursorPos
	return {
		buf = vim.api.nvim_get_current_buf(),
		cursor = vim.api.nvim_win_get_cursor(0),
	}
end

---@param a CursorPos
---@param b CursorPos
---@return boolean
local function same_pos(a, b)
	return a.buf == b.buf and a.cursor[1] == b.cursor[1] and a.cursor[2] == b.cursor[2]
end

---@param pos CursorPos
local function push(pos)
	if M.index ~= nil then
		local cur = M.stack[M.index]
		if cur and same_pos(cur, pos) then
			return
		end
	end

	-- Clear forward history if branching
	if M.index and M.index < #M.stack then
		for i = M.index + 1, #M.stack do
			M.stack[i] = nil
		end
	end

	M.stack[#M.stack + 1] = pos
	M.index = #M.stack

	if #M.stack > M.max_size then
		table.remove(M.stack, 1)
		M.index = math.max(1, M.index - 1)
	end
end

-- Records both origin and destination for jumps (gd, gD, etc.)
function M.record()
	if M.pending then
		return
	end
	M.pending = true

	local origin = get_pos()

	vim.api.nvim_create_autocmd("CursorMoved", {
		once = true,
		callback = function()
			-- Push origin
			push(origin)

			-- Push destination
			local dest = get_pos()
			push(dest)

			M.pending = false
		end,
	})
end

-- Record selected reference from the quickfix list.
---@param origin CursorPos
---@return boolean
local function record_selected_reference(origin)
	local item = vim.fn.getqflist({
		idx = 0,
		items = 0,
	})

	local idx = item.idx

	if not idx or idx == 0 then
		return false
	end

	local qf_item = vim.fn.getqflist()[idx]

	if not qf_item then
		return false
	end

	if not qf_item.bufnr or qf_item.bufnr == 0 then
		return false
	end

	local destination = {
		buf = qf_item.bufnr,
		cursor = {
			qf_item.lnum,
			math.max(qf_item.col - 1, 0),
		},
	}

	-- Don't record special buffers.
	if vim.bo[destination.buf].buftype ~= "" then
		return false
	end

	push(origin)
	push(destination)

	M.pending = false

	return true
end

-- Records the origin and the selected destination from gr.
function M.record_references()
	if M.pending then
		return
	end

	M.pending = true

	local origin = get_pos()

	local autocmd_id

	autocmd_id = vim.api.nvim_create_autocmd("CursorMoved", {
		callback = function()
			-- Ignore movement inside the quickfix window.
			if vim.bo.buftype == "quickfix" then
				return
			end

			vim.schedule(function()
				if not M.pending then
					return
				end

				if record_selected_reference(origin) then
					vim.api.nvim_del_autocmd(autocmd_id)
				end
			end)
		end,
	})

	-- Don't leave M.pending stuck forever if the user closes/cancels gr.
	vim.defer_fn(function()
		if M.pending then
			M.pending = false
			pcall(vim.api.nvim_del_autocmd, autocmd_id)
		end
	end, 30000)
end

---@param pos CursorPos|nil
local function jump(pos)
	if not pos then
		return
	end

	-- Prevent recording during programmatic jumps
	M.pending = true

	vim.api.nvim_set_current_buf(pos.buf)
	vim.api.nvim_win_set_cursor(0, pos.cursor)

	-- Allow recording again on next user movement
	vim.schedule(function()
		M.pending = false
	end)
end

function M.back()
	if M.index and M.index > 1 then
		M.index = M.index - 1
		jump(M.stack[M.index])
	end
end

function M.forward()
	if M.index and M.index < #M.stack then
		M.index = M.index + 1
		jump(M.stack[M.index])
	end
end

return M
