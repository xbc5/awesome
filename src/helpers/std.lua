-- Pass in a table an use func to map out a new table.
-- @param table a table with any values.
-- @param func a function that you use to alter the values of the table.
--  Its only parameter is each value of the table. The return value is the
--  new value for the key.
-- @return a new, transformed table.
function map(table, func)
  local t = {}
  for k, v in ipairs(table) do
    t[k] = func(v)
  end
  return t
end


-- Pass in a table an use func to filter out desired values.
-- @param table a table with any values.
-- @param func a function that you use to filter the values of the table.
--  Its only parameter is each value of the table. The return value must be 
--   either truthy or falsy. If truthy the value is omitted; falsy it's not.
-- @return a new, filtered table.
function filter(table, func)
  local t = {}
  for _, v in ipairs(table) do
    if not func(v) then
      table.insert(t, v)
    end
  end
  return t
end


-- A poor man's len for tables. It uses ipair, so it works only for
--  sequential lists.
-- @param table a table with sequential indexes -- 1 => n.
-- @return a number, the length of the table.
function len(table)
  local size = 0
  for i, _ in ipairs(table) do size = i end
  return size
end


return { map = map, filter = filter, len = len }
