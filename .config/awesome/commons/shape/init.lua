local beautiful = require("beautiful")
local gears     = require("gears")

local shape_utils = {

  rounded_rect = function(radius)
      return function(cr, width, height)
          gears.shape.rounded_rect(cr, width, height, radius or beautiful.rounded)
      end
  end,


  partially_rounded_rect = function(tl, tr, br, bl, radius)
      return function(cr, width, height)
          gears.shape.partially_rounded_rect(cr, width, height, tl, tr, br, bl,
                                             radius or beautiful.rounded)
      end
  end,


  circle = function(radius)
      return function(cr, width, height)
          gears.shape.circle(cr, radius, radius)
      end
  end,


  pie_half_pi = function(size, angle_start, angle_end)
      return function(cr, width, height)
          gears.shape.pie(cr, size, size, angle_start, angle_end)
      end
  end

}

shape_utils.default_frr    = shape_utils.rounded_rect(beautiful.rounded)
shape_utils.default_circle = shape_utils.circle(beautiful.rounded)

shape_utils.pie_half_left = function()
    local half_pi = math.pi / 2
    return shape_utils.pie_half_pi(20, half_pi, 0 - half_pi)
end

shape_utils.pie_half_right = function()
    local half_pi = math.pi / 2
    return shape_utils.pie_half_pi(20, 0 - half_pi, half_pi)
end




return shape_utils
