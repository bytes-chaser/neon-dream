local beautiful   = require("beautiful")
local gears       = require("gears")
local shape_utils = require("commons.shape")

local function client_decoration_rounding()


    local function configure_client(c)
        c.shape = client_shape(c)
    end
    

    function client_shape (c)
        if c.fullscreen then
            return nil
        elseif c.maximized then
            return shape_utils.partially_rounded_rect(beautiful.rounded, true, true, false, false)
        else
            return shape_utils.rounded_rect(beautiful.rounded)
        end
    end


    if beautiful.rounded and beautiful.rounded > 0 then
        client.connect_signal("manage", configure_client)        
        client.connect_signal("property::fullscreen", configure_client)
        client.connect_signal("property::maximized", configure_client)
        beautiful.snap_shape = shape_utils.rounded_rect(beautiful.rounded)
    else
        beautiful.snap_shape = gears.shape.rectangle
    end
end

client_decoration_rounding()