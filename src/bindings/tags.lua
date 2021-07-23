-- Do all tag bindings in here. Use set_multi to bind keys to multiple tags.
-- You must use the global tags config object, so do your configuration in there.
-- You can bind a single action to a key with set_one.
local awful = require("awful")

local h = {
  client = require("helpers.client")
}

-- The act of viewing a tag; this is an action that you bind
--  to a key.
-- @param index the index of the tag.
-- @return nil
function view(index)
  local screen = awful.screen.focused()
  local tag = screen.tags[index]
  if tag then
    tag:view_only()
  end
end

-- Toggle a tag; this is an action that you bind to a key.
--  to a key.
-- @param index the index of the tag.
-- @return nil
function toggle(index)
  local screen = awful.screen.focused()
  local tag = screen.tags[index]
  if tag then
    awful.tag.viewtoggle(tag)
  end
end

-- Move a tag. Provide a single tag info table, it will
--  derive the tag name from that;
-- this is an action that you bind to a key.
-- @param _ ignore this
-- @param conf a single tags.info table -- i.e. one tag.
function move(_, conf) h.client.move_to(conf.name, client.focus) end

-- Bind a key to a given action.
-- @param desc a textual description for keybinding docs.
-- @param key a textual character to bind to.
-- @param a mods table identical to the one passed into awful.key, essentially
--  these define the modifier keys.
-- @param action a function to bind to the key. It takes no parameters.
-- @return nil
function set_one(desc, key, mods, action)
  awful.keyboard.append_global_keybindings(
    {awful.key(mods, key, action, {
      description = desc,
      group = "tag"
    })})
end

-- Bind multiple tags -- they should all use the same mod key.
-- @param tags_info a table of tag info tables -- as defined in the global config.
-- @param mods a mods table identical to the one passed into awful.key, essentially
--  these define the modifier keys.
-- @param desc a format string use for keybind description, where the placeholder 
--  (e.g. %s) is replaced with the tag name.
-- @param action a function that takes the tag index as its first parameter and a tag
--  info config table as its second.
-- @return nil
function set_multi(tags_info, mods, desc, action)
  -- go through tags, inject tag name into message, and bind the configured keys to
  --  the configured mods. Associate the binding with the injected action.
  for i, tag in ipairs(tags_info) do
    local _desc = string.format(desc, tag.name)
    set_one(_desc, tag.key, mods, function() action(i, tag) end)
  end
end

return {
  -- Set all key bindings configured in the global tags config object.
  -- @param conf the global tags config object.
  -- @return nil
  set = function(conf)
    set_multi(conf.info, conf.mods.view, "view %s", view) -- bind tag viewing.
    set_multi(conf.info, conf.mods.toggle, "toggle %s", toggle) -- bind tag toggling.
    set_multi(conf.info, conf.mods.move, "move focused client to %s", move) -- bind client moving.
  end
}
