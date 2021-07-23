-- awesome_mode: api-level=4:screen=on
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

local awful = require("awful")
local debug = require("gears.debug")
require("awful.autofocus")
-- Notification library
local naughty = require("naughty")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

local tags = require("main.tags")
local layouts = require("main.layouts")
local bindings = {
  tags = require("bindings.tags"),
  global = require("bindings.global")
}
local conf = {
  default = require("conf.default")
}
local mywidgets = require("widgets.init")

local my = {
  rules = require("main.rules"),
  theme = require("main.theme"),
  client = require("main.client"),
}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal("request::display_error", function(message, startup)
  naughty.notification {
    urgency = "critical",
    title = "Oops, an error happened" .. (startup and " during startup!" or "!"),
    message = message
  }
end)
-- }}}

-- {{{ Variable definitions
-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
-- }}}

-- {{{ Key bindings

awful.keyboard.append_global_keybindings({awful.key {
  modifiers = {modkey, "Control", "Shift"},
  keygroup = "numrow",
  description = "toggle focused client on tag",
  group = "tag",
  on_press = function(index)
    if client.focus then
      local tag = client.focus.screen.tags[index]
      if tag then
        client.focus:toggle_tag(tag)
      end
    end
  end
}, awful.key {
  modifiers = {modkey},
  keygroup = "numpad",
  description = "select layout directly",
  group = "layout",
  on_press = function(index)
    local t = awful.screen.focused().selected_tag
    if t then
      t.layout = t.layouts[index] or t.layout
    end
  end
}})

client.connect_signal("request::default_mousebindings", function()
  awful.mouse.append_client_mousebindings(
    {awful.button({}, 1, function(c)
      c:activate{
        context = "mouse_click"
      }
    end), awful.button({modkey}, 1, function(c)
      c:activate{
        context = "mouse_click",
        action = "mouse_move"
      }
    end), awful.button({modkey}, 3, function(c)
      c:activate{
        context = "mouse_click",
        action = "mouse_resize"
      }
    end)})
end)

client.connect_signal("request::default_keybindings", function()
  awful.keyboard.append_client_keybindings(
    {awful.key({modkey}, "f", function(c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end, {
      description = "toggle fullscreen",
      group = "client"
    }), awful.key({modkey, "Shift"}, "c", function(c) c:kill() end, {
      description = "close",
      group = "client"
    }), awful.key({modkey, "Control"}, "space", awful.client.floating.toggle, {
      description = "toggle floating",
      group = "client"
    }), awful.key({modkey, "Control"}, "Return",
      function(c) c:swap(awful.client.getmaster()) end, {
        description = "move to master",
        group = "client"
      }), awful.key({modkey}, "o", function(c) c:move_to_screen() end, {
      description = "move to screen",
      group = "client"
    }), awful.key({modkey}, "t", function(c) c.ontop = not c.ontop end, {
      description = "toggle keep on top",
      group = "client"
    }), awful.key({modkey}, "n", function(c)
      -- The client currently has the input focus, so it cannot be
      -- minimized, since minimized clients can't have the focus.
      c.minimized = true
    end, {
      description = "minimize",
      group = "client"
    }), awful.key({modkey}, "m", function(c)
      c.maximized = not c.maximized
      c:raise()
    end, {
      description = "(un)maximize",
      group = "client"
    }), awful.key({modkey, "Control"}, "m", function(c)
      c.maximized_vertical = not c.maximized_vertical
      c:raise()
    end, {
      description = "(un)maximize vertically",
      group = "client"
    }), awful.key({modkey, "Shift"}, "m", function(c)
      c.maximized_horizontal = not c.maximized_horizontal
      c:raise()
    end, {
      description = "(un)maximize horizontally",
      group = "client"
    })})
end)

-- }}}

naughty.connect_signal("request::display", function(n)
  naughty.layout.box {
    notification = n
  }
end)

-- ##### KEEP
-- ! init theme before desktop_decoration -- otherwise colours etc are not set.
my.theme.init("default")

screen.connect_signal("request::desktop_decoration", function(s)
  tags.set(s, conf.default.tags)
  mywidgets(s, conf.default.widgets)
end)
tag.connect_signal("request::default_layouts", layouts.set)

my.rules.init(conf.default.rules)


bindings.global.set(conf.default.global)
bindings.tags.set(conf.default.tags)
my.client.init()
-- ##### PEEK
