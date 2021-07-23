local M = {}


-- Given the global conf app info, return a function that you can use for
--  that app to define a matching X window class name for Qubes.
-- @param domain a string name of the target domain.
-- @param index reference an index on the app_info table, typically 1 is the
--  most frequented app, 2 second most etc.
-- @example class(app.browser)(domains.daily) => untrusted:Firefox
-- @return a function that returns a Qubes compatible class string, e.g. untrusted:Firefox
function M.class(app_info) -- app_info is list
  return function(domain, index)
    local i = index or 1
    if i > #app_info then return nil end -- TODO do error logging

    local class = app_info[i].class
    
    if domain == "dom0" then return class end

    return domain..":"..class
  end
end


return M
