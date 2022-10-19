local beautiful   = require("beautiful")
local dpi         = beautiful.xresources.apply_dpi
local gears       = require("gears")
local wibox       = require("wibox")

return {
    notification = function(n)
        return {
            notification = n,
            type = "notification",
            cursor = "hand2",
            shape = gears.shape.rectangle,
            maximum_width = dpi(350),
            maximum_height = dpi(180),
            bg = beautiful.bg_normal,
            widget_template =
            {
                {
                    image = n.icon,
                    resize = true,
                    clip_shape = gears.shape.circle,
                    halign = "center",
                    valign = "center",
                    widget = wibox.widget.imagebox,
                },
                {
                    {
                        widget = wibox.widget.textbox,
                        markup = "<span foreground='" .. beautiful.fg_focus .."'><b>" .. n.title .."</b></span>",
                        font     = beautiful.font_famaly .. '12',
                    },
                    {
                        widget = wibox.widget.textbox,
                        text = n.message
                    },
                    layout = wibox.layout.fixed.vertical
                },
                layout = wibox.layout.fixed.horizontal
            }
        }
    end
}