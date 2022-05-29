local gears = require("gears")

local shape_utils = {}


function shape_utils.rounded_rect(radius)
    return function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, radius)
    end
end


function shape_utils.partially_rounded_rect(radius, tl, tr, br, bl)
    return function(cr, width, height)
        gears.shape.partially_rounded_rect(cr, width, height, tl, tr, br, bl,
                                           radius)
    end
end

return shape_utils