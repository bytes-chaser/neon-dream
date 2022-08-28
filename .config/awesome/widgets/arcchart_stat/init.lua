local awful                = require("awful")
local beautiful            = require("beautiful")
local wibox                = require("wibox")
local dpi                  = require("beautiful").xresources.apply_dpi

return {
    create = function(content)

        return wibox.widget({
            widget  = wibox.container.margin,
            margins = dpi(10),
            {
                id = 'mirr',
                widget = wibox.container.mirror,
                reflection = {
                    horizontal = true
                },
                {
                    id = 'bar',
                    widget = wibox.container.arcchart,
                    min_value    = 0,
                    value        = 20,
                    max_value    = 100,
                    thickness    = dpi(10),
                    paddings     = dpi(5),
                    bg           = beautiful.pallete_c2,
                    colors       = {beautiful.pallete_c1},
                    start_angle  = 4.71239,
                    {
                        widget = wibox.container.mirror,
                        reflection = {
                            horizontal = true
                        },
                        content
                    }
                }


            }
        })
    end
}