local awful = require("awful")

function launch(app) return function() awful.spawn(app) end end


return {
  launch = launch
}

