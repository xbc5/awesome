local awful = require("awful")
local std = require("helpers.std")
local error = require("helpers.error")


local M = {}


-- Derive a table of tag names from the global tag config.
-- @param tags_info a table of info for tags, as defined in the global tag config. 
-- @return a table of ordered tag names, in order of specification.
local function get_names(tags_info)
  return std.map(tags_info, function(item)
    error.assert(item.name and item.name ~= "", "A tag name is not set, you must set it", item)
    return item.name
  end)
end


-- Derive a table of layouts from the global tag config, these are awful.layouts.suit
--  tables.
-- @param tags_info a table of info for tags, as defined in the global tag config. 
-- @return a table of ordered  awful.layout.suit, in order of specification.
local function get_assigned_layouts(tags_info)
  return std.map(tags_info, function(item)
    return item.layout or awful.layout.suit.max -- default
  end)
end


-- Set all configured tag names in order of their specification.
-- @param s an awesomewm screen table.
-- @param conf the global config for tags.
-- @return nil.
function M.set(s, conf)
    awful.tag(
      get_names(conf.info),           -- a table of tag names.
      s,                              -- an awesome screen.
      get_assigned_layouts(conf.info) -- a corresponding table of layouts.
    )
end


return M