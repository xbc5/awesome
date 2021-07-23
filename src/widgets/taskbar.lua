local awful = require("awful")
local wibox = require("wibox")


return function(s, conf, widgets)
  local fixed_h = wibox.layout.fixed.horizontal
  local align_h = wibox.layout.align.horizontal
  
  -- you MUST include a layout, otherwise they're not recognised as widgets.
  widgets.left.layout = fixed_h
  widgets.middle.layout = fixed_h
  widgets.right.layout = fixed_h

  local mywibox = awful.wibar({ position = conf.position, screen = s })

  -- append your widgets
  mywibox.widget = { layout = align_h, widgets.left, widgets.middle, widgets.right }
    
end
