local wibox     = require("wibox")
local beautiful = require("beautiful")
local dpi       = beautiful.xresources.apply_dpi
local gears     = require("gears")
local icons     = require("commons.icons")

pbar = {}

pbar.create_shaped_points_pbar = function(parameters)

    local shape = parameters.shape or gears.shape.circle
    local bg_color = parameters.bg_color or beautiful.pbar_bg_color
    local p_heigth = parameters.p_heigth or beautiful.pbar_heigth
    local p_width = parameters.p_width or beautiful.pbar_width
    local p_margin = parameters.p_margin or beautiful.pbar_margin


    local function create_point(index, shape, bg_color, p_heigth, p_width, p_margin)
        local point = wibox.widget{
            {
                id = "point",
                icons.wbi(index, 0),
                widget = wibox.container.background,
                forced_height = dpi(p_heigth),
                forced_width  = dpi(p_width),
                shape = shape,
                bg = bg_color,
            },
            id ="mbox",
            left = dpi(p_margin),
            widget = wibox.container.margin,
        }

        return point
    end


    local points = {}
    for i = 1, 10
    do
        points[i] = create_point(i, shape, bg_color, p_heigth, p_width, p_margin)
    end

    points.layout = wibox.layout.fixed.horizontal
    points.id = "arr"
    return wibox.widget{
        id = "bar_body",
        points,
        shape  = gears.shape.rounded_bar,
        widget = wibox.container.background,
    }
end

return pbar
