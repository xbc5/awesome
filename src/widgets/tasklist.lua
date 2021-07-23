local awful = require("awful")


return function(s)
  return awful.widget.tasklist {
    screen  = s,
    filter  = awful.widget.tasklist.filter.currenttags,
  }
end
