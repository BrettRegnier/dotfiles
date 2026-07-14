-- ~/.config/nvim/lua/custom/color-utils.lua
local M = {}

function M.darken(hex, amount)
	local r = tonumber(hex:sub(2, 3), 16)
	local g = tonumber(hex:sub(4, 5), 16)
	local b = tonumber(hex:sub(6, 7), 16)
	r = math.floor(r * (1 - amount))
	g = math.floor(g * (1 - amount))
	b = math.floor(b * (1 - amount))
	return string.format("#%02x%02x%02x", r, g, b)
end

function M.lighten(hex, amount)
	local r = tonumber(hex:sub(2, 3), 16)
	local g = tonumber(hex:sub(4, 5), 16)
	local b = tonumber(hex:sub(6, 7), 16)
	r = math.floor(r + (255 - r) * amount)
	g = math.floor(g + (255 - g) * amount)
	b = math.floor(b + (255 - b) * amount)
	return string.format("#%02x%02x%02x", r, g, b)
end

return M
