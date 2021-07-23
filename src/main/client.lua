local awful = require("awful")
local qubes = require("helpers.qubes")


local M = {}


local function set_titlebar(c)
	awful.titlebar(c, { 
		size = 8,
		bg_normal = c.qubes_label_color_unfocus,
		bg_focus = c.qubes_label_color_focus,
	})
end


function M.init()
	-- When a new client is opened (i.e. "managed" by awesome).
	client.connect_signal("request::manage", function(c)
		qubes.set_label(c) -- sets domain colour props on client
		set_titlebar(c)
	end)
end


return M