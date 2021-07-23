local debug = require("gears.debug")


local M = {}


function M.assert(predicate, message, data)
    assert(predicate or debug.dump(data), message)
end


function M.debug(f, input, message)
    debug.dump(input)
    assert(f(input), message)
    return input
end


return M