local beautiful   = require("beautiful")
local dpi         = beautiful.xresources.apply_dpi
local shapes      = require("commons.shape")
local gears       = require("gears")
local wibox       = require("wibox")


local last_player_notification = nil

return {
    notification = function(n)
        if last_player_notification ~= nil then
            last_player_notification:destroy()
        end

        last_player_notification = n

        return {
            notification = n,
            type = "notification",
            cursor = "hand2",
            shape = gears.shape.rectangle,
            maximum_width = dpi(350),
            maximum_height = dpi(220),
            bg = beautiful.bg_normal,
            widget_template =
            {
                spacing = 10,
                layout = wibox.layout.fixed.horizontal,
                {
                    image = n.icon,
                    resize = true,
                    forced_height = 100,
                    forced_width = 100,
                    clip_shape = shapes.default_frr,
                    halign = "left",
                    valign = "center",
                    widget = wibox.widget.imagebox,
                },
                {
                    widget = wibox.container.margin,
                    margin = dpi(10),
                    {
                        spacing = 10,
                        layout = wibox.layout.fixed.vertical,
                        {
                            widget = wibox.widget.textbox,
                            markup = "<span foreground='" .. beautiful.fg_focus .."'><b>" .. n.title .."</b></span>",
                            font     = beautiful.font_famaly .. '12',
                        },
                        {
                            layout        = wibox.container.scroll.horizontal,
                            max_size      = 200,
                            speed         = 100,
                            step_function = wibox.container.scroll.step_functions.nonlinear_back_and_forth,
                            {
                                markup = "<b>" .. n.message .."</b>",
                                widget = wibox.widget.textbox,
                                font   = beautiful.font_famaly .. '12',
                            },
                        }
                    }
                }
            }
        }
    end
}