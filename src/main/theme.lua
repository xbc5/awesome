local beautiful = require("beautiful")
local gears = require("gears")


local M = {}


function M.dir()
		return gears.filesystem.get_configuration_dir() .. "themes/"
end


function M.file(name)
		return M.dir() .. name .. "/theme.lua"
end


function M.set_wallpaper(s, wallpaper)
		if wallpaper then
			-- If wallpaper is a function, call it with the screen
			if type(wallpaper) == "function" then
				wallpaper = wallpaper(s)
			end
			gears.wallpaper.maximized(wallpaper, s, true)
		end
end


-- Initialise the theme, and set the wallpaper; either use the theme wallpaper, or pass in a
--  path or function.
-- @param wallpaper is nil, a path, or a function which returns a path (that also accepts a
--  screen arg); if it's nil then the theme wallpaper is used (beautiful.wallpaper).
-- @return nil
-- @example init("default", function(s) return example(s).path end).
-- @example init("default", "/foo.png").
function M.init(name, wallpaper)
	beautiful.init(M.file(name))
	
	local wp = wallpaper or beautiful.wallpaper -- ! run after beautiful.init()
	
	-- TODO replace wallpaper dynamically. this callback will probbaly need replaced on demand.
	screen.connect_signal("request::wallpaper", function(s)
		-- when a screen requests a wallpaper, set it
		M.set_wallpaper(s, wp)
	end)
end

return M