local hotkeys = require("awful.hotkeys_popup")
local awful = require("awful")
local gears = require("gears")

local launch = require("helpers.sys").launch
local keys = require("helpers.keys").keys
local swap_with = require("helpers.client").swap_with
local focusx = require("helpers.client").focusx
local toggle_focus = require("helpers.client").toggle_focus
local unminimise = require("helpers.client").unminimise
local adjust_width = require("helpers.layout").adjust_width
local inc_masters = require("helpers.layout").inc_masters
local inc_layouts = require("helpers.layout").inc_layouts
local inc_cols = require("helpers.layout").inc_cols
local xprop = require("helpers.xprop")
local pattern = require("helpers.pattern")
local error = require("helpers.error")


local layout = awful.layout.suit


local M = {}


local apps = {
  volume = {
    { bin = "pavucontrol", class = "Pavucontrol" },
  },
  qube_manager = {
    { bin = "qubes-qube-manager", class = "Qubes-qube-manager" },
  },
  terminal = {
    { bin = "kitty", class = "kitty" },
    { bin = "xfce4-terminal", class = "Xfce4-terminal" },
  },
  launcher = {
    scripts = { bin = "launch", class = "Rofi" },
    search = { bin = "search", class = "Rofi" },
  },
  notes = {
    { bin = "emacs", class = "Emacs" },
  },
  reader = {
    { bin = "zathura", class = "Zathura" },
  },
  browser = {
    { bin = "firefox", class = "browser" },
    { bin = "chromium", class = "Chromium" },
  },
  dev_browser = {
    { bin = "firefox", class = "dev-browser" },
    { bin = "chromium", class = "Chromium" },
  },
  youtube = {
    { bin = "firefox", class = "youtube"},
    { bin = "chromium", class = "Chromium" },
  },
  ide = {
    { bin = "codium", class = "VSCodium" },
  },
}


local function study_apps()
  return gears.table.join(apps.notes, apps.reader)
end


local function get_classes(t)
  return gears.table.map(function(v) return v.class end, t)
end


local domains = {
  daily = "untrusted",
  dev = "dev",
  dom0 = "dom0",
  financial = "financial",
  fw = { "mfw", "fw-vpn" },
  matrix = "matrix",
  misc = "misc",
  net = "net",
  personal = "personal",
  temp = "temp",
  test = "test",
  templates = "templates",
  util = "util",
  vault = "vault",
  vpn = { "vpn", "vpn-temp" },
}


local function net_domains()
  return { domains.net, domains.fw[1], domains.fw[2], domains.vpn[1], domains.vpn[2] }
end



local tags = {
  -- chat
  matrix = domains.matrix,
  -- daily
  daily = "daily" .. ":browser",
  youtube = "daily" .. ":yt",
  -- dev
  ide = domains.dev .. ":code",
  dev_browser = domains.dev .. ":browser",
  dev_term = domains.dev .. ":term",
  -- dom0
  dom0 = domains.dom0,
  util = domains.util,
  -- misc
  misc1 = domains.misc .. ":1",
  misc2 = domains.misc .. ":2",
  -- personal
  personal = domains.personal,
  -- study
  notes = "notes",
  read = "read",
  -- temp
  temp = domains.temp,
  test = domains.test,
  -- templates
  templates = domains.templates,
  -- secure
  financial = domains.financial,
  vault = domains.vault,
  -- net
  net = domains.net,
}


local class = {
  terminal = xprop.class(apps.terminal),
  browser = xprop.class(apps.browser),
  youtube = xprop.class(apps.youtube),
  ide = xprop.class(apps.ide),
  volume_control = xprop.class(apps.volume),
  qube_manager = xprop.class(apps.qube_manager),
}


M.tags = {
  -- Map keys to tags; used for defining tags and all relative key mappings,
  --  e.g. viewing, moving, toggling -- all of which will use the key defined here.
  info = {
    { name = tags.misc1, key = "1", layout = layout.max },
    { name = tags.misc2, key = "2", layout = layout.max },
    { name = tags.util, key = "q", layout = layout.max },
    { name = tags.daily, key = "m", layout = layout.max },
    { name = tags.youtube, key = ",", layout = layout.max },
    { name = tags.dom0, key = "s", layout = layout.tile.left },
    { name = tags.test, key = "5", layout = layout.tile.left },
    { name = tags.templates, key = "t", layout = layout.tile.left },
    { name = tags.temp, key = "7", layout = layout.max },
    { name = tags.ide, key = "n", layout = layout.max },
    { name = tags.dev_term, key = "u", layout = layout.tile.left },
    { name = tags.notes, key = "b", layout = layout.tile.left },
    { name = tags.read, key = "e", layout = layout.tile.left },
    { name = tags.net, key = "w", layout = layout.tile.left },
    { name = tags.matrix, key = "g", layout = layout.max },
  },
  -- The required mod keys for the specified tag actions. These will combine with
  --  the keys defined above. Each value must be a table.
  mods = {
    view = { keys.super },                -- when viewing a tag.
    toggle = { keys.super, keys.alt },    -- when toggling a tag on/off.
    move = { keys.super, keys.control },  -- when moving a client.
  },
}

M.global = {
  awesome = {
    mods = { keys.super, keys.shift }, -- default mods
    conf = {
      { desc = "show help", key = "s", action = hotkeys.show_help },
      { desc = "reload", key = "r", action = awesome.restart },
      { desc = "quit", key = keys.escape, action = awesome.quit },
    },
  },
  launcher = {
    mods = { keys.super, keys.shift }, -- default mods
    conf = {
      { desc = "terminal", key = keys.enter, action = launch(apps.terminal[2].bin) },
      { desc = "launcher", key = "z", action = launch(apps.launcher.scripts.bin), mods = { keys.super }},
      { desc = "search the web", key = "a", action = launch(apps.launcher.search.bin), mods = { keys.super }},
    },
  },
  client = {
    mods = { keys.super, keys.shift }, -- default mods
    conf = {
      { desc = "swap client down", key = "j", action = swap_with(1) },
      { desc = "swap client up", key = "k", action = swap_with(-1) },
      { desc = "jump to urgent", key = "u", action = awful.client.urgent.jumpto },
      { desc = "focus next", key = "j", action = focusx(1), mods = { keys.super }},
      { desc = "focus prev", key = "k", action = focusx(-1), mods = { keys.super}},
      { desc = "toggle focus", key = keys.tab, action = toggle_focus, mods = { keys.super }},
      { desc = "restore all minimised", key = "n", action = unminimise, mods = { keys.super, keys.control }},
    },
  },
  layout = {
    mods = { keys.super },
    conf = {
      { desc = "++master width", key = "l", action = adjust_width(0.05), mods = { keys.super }},
      { desc = "--master width", key = "h", action = adjust_width(-0.05), mods = { keys.super}},
      { desc = "++number of masters", key = "h", action = inc_masters(1), mods = { keys.super, keys.shift }},
      { desc = "--number of masters", key = "l", action = inc_masters(-1), mods = { keys.super, keys.shift }},
      { desc = "++number of columns", key = "h", action = inc_cols(1), mods = { keys.super, keys.control }},
      { desc = "--number of columns", key = "l", action = inc_cols(-1), mods = { keys.super, keys.control }},
      { desc = "select next layout", key = "space", action = inc_layouts(1) }, -- TODO use explicit bindings instead
    },
  },
}

M.widgets = {
  taskbar = {
    position = "top",
  },
}

M.rules = {
  client = {
    {
      id = "global",
      rule = {},
      properties = {
        focus = awful.client.focus.filter,
        raise = true,
        screen = awful.screen.preferred,
        placement = awful.placement.no_overlap + awful.placement.no_offscreen,
      },
    },
    {
      id = "floating-dialogue",
      rule_any = {
        name = "Save As",
      },
      properties = {
        floating = true,
      },
    },
    {
      id = "daily-browser",
      rule = {
        class = error.debug(function(v) return v end, class.browser(domains.daily), "browser has falsy match"),
      },
      properties = {
        screen = 1,
        tag = tag.daily,
      },
    },
    {
      id = "youtube",
      rule = {
        class = error.debug(function(v) return v end, class.youtube(domains.daily), "browser has falsy match"),
      },
      properties = {
        screen = 1,
        tag = tag.youtube,
      },
    },
    {
      id = "ide",
      rule = {
        class = class.ide(domains.dev),
      },
      properties = {
        screen = 1,
        tag = tags.ide,
      },
    },
    {
      id = "dev-terminal",
      rule = {
        class = class.terminal(domains.dev),
      },
      properties = {
        screen = 1,
        tag = tags.dev_term,
      },
    },
    {
      id = "net",
      rule_any = {
        class =  pattern.match_all_domains(net_domains()),
      },
      properties = {
        screen = 1,
        tag = tags.net,
      },
    },
    {
      id = "notes",
      rule_any = {
        class =  pattern.match_all_classes(get_classes(apps.notes)),
      },
      properties = {
        screen = 1,
        tag = tags.notes,
      },
    },
    {
      id = "read",
      rule_any = {
        class =  pattern.match_all_classes(get_classes(apps.reader)),
      },
      properties = {
        screen = 1,
        tag = tags.read,
      },
    },
    {
      id = "temp",
      rule_any = {
        class = { pattern.match_domu(domains.temp) },
      },
      properties = {
        screen = 1,
        tag = tags.temp,
      },
    },
    {
      id = "test",
      rule_any = {
        class = { pattern.match_domu(domains.test) },
      },
      properties = {
        screen = 1,
        tag = tags.test,
      },
    },
    {
      id = "util",
      rule_any = {
        class = pattern.match_all_classes({
          class.volume_control("dom0"),
          class.qube_manager("dom0"),
        }),
      },
      properties = {
        screen = 1,
        tag = tags.util,
      },
    },
    {
      id = "dom0-terminal",
      rule = {
        class = class.terminal(domains.dom0, 2),
      },
      properties = {
        screen = 1,
        tag = domains.dom0,
      },
    },
  },
  notification = {
    {
      id = "notification",
      rule = {},
      properties = {
        screen = awful.screen.preferred,
        implicit_timeout = 5,
      },
    },
  },
}


return M
