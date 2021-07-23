local awful = require("awful")

local std = require("helpers.std")

-- Get the selected tags from the focused screen,
--  or from the passed in screen object.
-- @param screen? an awful.screen object, defaults to the
--  focused screen.
-- @return a table of awful.tag | nil (none found).
function selected(screen)
  local screen = screen or awful.screen.focused()
  if screen then
    return screen.selected_tags
  end
end


-- Get a tag by name.
-- @param name the name of the tag.
-- @param screen? the target screen, defaults to the focused.
-- @return awful.tag | nil.
function get(name, screen)
  local s = screen or awful.screen.focused()
  return awful.tag.find_by_name(s, name)
end


-- Get a tag from a given key binding;
-- this is useful for callbacks bound to awful.key,
--  which passes in a key char;
-- this key must be specified in the global tags config;
-- additionally, in case of duplicate bindings, only
--  the first is returned -- you have been warned.
-- @param key a key character.
-- @param tags the global tags info config table.
-- @param screen? the target screen, defaults to the focused.
-- @return an awful.tag table | nil (not found).
function from_binding(key, tags, screen)
  local filtered = std.filter(tags, function(tag) return tag.key ~= key end)
  if filtered[1] then return get(filtered[1].name, screen) end
end


return { selected = selected, get = get, from_binding = from_binding }
