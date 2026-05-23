local M = {
	darken = function(color, percent)
		local r = math.floor(color / 0x10000)
		local g = math.floor((color / 0x100) % 0x100)
		local b = math.floor(color % 0x100)
		local function mix(x)
			return math.floor(x * (1 - percent))
		end
		return string.format("#%02x%02x%02x", mix(r), mix(g), mix(b))
	end,
	lighten = function(color, percent)
		if not color then
			return "none"
		end
		local r = math.floor(color / 0x10000)
		local g = math.floor((color / 0x100) % 0x100)
		local b = math.floor(color % 0x100)
		local function mix(x)
			return math.floor(x + (255 - x) * percent)
		end
		return string.format("#%02x%02x%02x", mix(r), mix(g), mix(b))
	end,
	folder_exists = function(path)
		local ok, err_str, err_code = os.rename(path, path)

		if ok == nil then
			if err_code == 13 then
				-- permission denied but folder exists
				return true
			end
			return false
		end
		return true
	end,
}
return M
