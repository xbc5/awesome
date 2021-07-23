local ruled = require("ruled")


local M = {}


-- Append rules to a target, and connect to the related signal.
-- @example apply("client", {}) appends {} to ruled.client
-- @example apply("notification", {}) appends {} to ruled.notification
-- @param target the target rules: e.g. ruled[target] => ruled.client
-- @param rules an awesome ruled table
-- @return nil
function M.apply(target, rules)
  ruled[target].connect_signal('request::rules', function()
    for _, r in ipairs(rules) do
      ruled[target].append_rule(r)
    end
  end)
end


-- Go through all of the rule types from the given conf and apply each of them.
-- @param conf is the global rules config table, where each key is a rule type
--  -- e.g. client, notification etc.
-- @example init(conf.rules) => applies all rules, returns nil
-- @return nil
function M.init(conf)
  for target, rules in pairs(conf) do
    M.apply(target, rules)
  end
end


return M
