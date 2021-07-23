local gears = require("gears")


local M = {}


function M.match_domu(domain)
  return "^" .. domain .. ":.*"
end


function M.begins_with(str)
  return "^" .. str .. ".*"
end


function M.match_class(str)
  return "^[%w:]*" .. str .. "$"
end


function M.full_class(domain, app)
  return "^" .. domain .. ":" .. app .. "$"
end


-- t: table, f: a function that produces a match pattern.
function M.match_all(t, f)
	return gears.table.map(f, t)
end


function M.match_all_domains(domains)
	return M.match_all(domains, M.match_domu)
end


function M.match_all_classes(classes)
	return M.match_all(classes, M.match_class)
end


return M