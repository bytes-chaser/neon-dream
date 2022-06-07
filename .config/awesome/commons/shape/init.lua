local gears = require("gears")

local shape_utils = {}


function shape_utils.rounded_rect(radius)
    return function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, radius)
    end
end

function shape_utils.circle(radius)
    return function(cr, width, height)
        gears.shape.circle(cr, radius, radius)
    end
end

function shape_utils.partially_rounded_rect(radius, tl, tr, br, bl)
    return function(cr, width, height)
        gears.shape.partially_rounded_rect(cr, width, height, tl, tr, br, bl,
                                           radius)
    end
end


function shape_utils.pie_half_left()
    local half_pi = math.pi / 2
    return shape_utils.pie_half_pi(20, half_pi, 0 - half_pi)
end

function shape_utils.pie_half_right()
    local half_pi = math.pi / 2
    return shape_utils.pie_half_pi(20, 0 - half_pi, half_pi)
end


function shape_utils.pie_half_pi(size, angle_start, angle_end)
    return function(cr, width, height)
        gears.shape.pie(cr, size, size, angle_start, angle_end)
    end
end

return shape_utils
