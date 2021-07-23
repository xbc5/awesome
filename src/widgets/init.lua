local tags = require("main.tags")
local wibox = require("wibox")


local my = {
  taglist = require("widgets.taglist"),
  layoutbox = require("widgets.layoutbox"),
  tasklist = require("widgets.tasklist"),
  taskbar = require("widgets.taskbar")
}


return function(s, conf)
  local widgets = {
    left = {
      my.taglist(s),
    },
    middle = {
      my.tasklist(s),
    },
    right = {
      wibox.widget.systray(),
      wibox.widget.textclock(),
      my.layoutbox(s)
    }
  }

  my.taskbar(s, conf.taskbar, widgets)

end
