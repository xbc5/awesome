local awful = require("awful")


function bind(mods, group)
  return function(desc, key, action, optional_mods)
    local _mods = optional_mods or mods -- mod  overrides
    awful.keyboard.append_global_keybindings({
      awful.key(_mods, key, action, { description = desc, group = group })
    })
  end
end


function multi_bind(conf, group)
  local _bind = bind(conf.mods, group)
  for i, c in ipairs(conf.conf) do
    _bind(c.desc, c.key, c.action, c.mods)
  end
end


return {
  set = function(conf)
    multi_bind(conf.awesome, "awesome")
    multi_bind(conf.launcher, "launcher")
    multi_bind(conf.client, "client")
    multi_bind(conf.layout, "layout")
  end
}
