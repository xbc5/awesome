local tags = require("helpers.tags")
local awful = require("awful")


local M = {}


-- Move a client to a tag, given an awful.tag or a tag name.
-- @param tag either a tag name or an awful.tag.
-- @param client an awesomewm client.
-- @return nil
-- @example move_to("foo", client.focus)
function M.move_to(tag, client)
  if client == nil then return end  -- a client might not be in focus
  local t -- could be nil
  if type(tag) == "string" then t = tags.get(tag) else t = tag end
  if t then client:move_to_tag(t) end
end


-- Swap the current client with the client at the given index,
--  typically you'd use this to swap two clients next to each other;
-- this is a closure that returns a parameterless callback.
-- @param index the offset in terms of index places, for example 1 is
--  the next client, -1 is the previous.
-- @return a parameterless function you will use for callbacks.
-- @example local callback = swap_with(1)
function M.swap_with(offset)
  return function()
    awful.client.swap.byidx(offset)
  end
end


-- Focus the client at the given relative index,
--  typically you'd use this to focus on the next client;
-- this is a closure that returns a parameterless callback.
-- @param index the offset in terms of index places, for example 1 is
--  the next client, -1 is the previous.
-- @return a parameterless function you will use for callbacks.
-- @example local callback = focusx(1)
function M.focusx(offset)
  return function()
    awful.client.focus.byidx(offset)
  end
end


-- Toggle focus between two clients.
-- @return nil
function M.toggle_focus()
  awful.client.focus.history.previous()
  if client.focus then
    client.focus:raise()
  end
end


-- Uminimise all clients.
-- @return nil
function M.unminimise()
  local c = awful.client.restore()
  if c then
    c:activate { raise = true, context = "key.unminimize" }
  end
end


return M
