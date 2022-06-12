local wibox     = require("wibox")
local beautiful = require("beautiful")
local dpi       = beautiful.xresources.apply_dpi
local gears     = require("gears")
local icons     = require("commons.icons")
local naughty   = require("naughty")
pbar = {}

pbar.create_shaped_points_pbar = function(parameters)

    local shapes = parameters.shapes
    if shapes == nil then
      shapes = {}
      shapes[1] = gears.shape.circle
    end

    local bg_color = parameters.bg_color or beautiful.pbar_bg_color
    local p_heigth = parameters.p_heigth or beautiful.pbar_heigth
    local p_width = parameters.p_width or beautiful.pbar_width
    local p_margin = parameters.p_margin or beautiful.pbar_margin
    local points_amount = parameters.points_amount or 10

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

    local shape_index = 1

    local points = {}
    for i = 1, points_amount
    do

        points[i] = create_point(i, shapes[shape_index], bg_color, p_heigth, p_width, p_margin)
        shape_index = shape_index + 1

        if shape_index > #shapes then
          shape_index = 1
        end
    end

    points.layout = wibox.layout.flex.horizontal
    points.id = "arr"
    return wibox.widget{
        id = "bar_body",
        points,
        shape  = gears.shape.rounded_bar,
        widget = wibox.container.background,
    }
end

return pbar
