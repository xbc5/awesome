local awful = require("awful")


local M = {}


function M.adjust_width(factor)
  return function()
    awful.tag.incmwfact(factor)
  end
end


-- Increase/decrease the number of master clients.
-- @param num the number to increment by.
-- @return a function that serves as a callback, it takes
--  no parameters.
function M.inc_masters(num)
  return function()
    awful.tag.incnmaster(num, nil, true)
  end
end


-- Increase/decrease the number of columns.
-- @param num the number to increment by.
-- @return a function that serves as a callback, it takes
--  no parameters.
function M.inc_cols(num)
  return function()
    awful.tag.incncol(num, nil, true)
  end
end


-- Cycle through the layouts in increments.
-- @param num the number to increment by.
-- @return a function that serves as a callback, it takes
--  no parameters.
function M.inc_layouts(num)
  return function()
    awful.layout.inc(num)
  end
end


return M
