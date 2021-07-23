local awful = require("awful")


return function(screen)
  return awful.widget.taglist {
    screen  = screen,
    filter  = awful.widget.taglist.filter.all,
  }
end
