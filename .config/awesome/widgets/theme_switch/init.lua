local awful       = require("awful")
local gears       = require("gears")
local beautiful   = require("beautiful")
local dpi         = beautiful.xresources.apply_dpi
local commands    = require("commons.commands")
local theme_util  = require("commons.theme")
local shape_utils = require("commons.shape")
local wibox       = require("wibox")
local shape       = require("commons.shape")

is_theme_popup_opened = false

return {
    create = function(parameters)

        local icon = wibox.widget{
            text    = "",
            align   = parameters.alignment or beautiful.battery_aligment,
            opacity = parameters.opacity   or beautiful.battery_opacity,
            font    = beautiful.icons_font .. (parameters.size or beautiful.battery_size),
            widget  = wibox.widget.textbox,
        }

        local scroll = {
            widget = wibox.widget.separator,
            shape  = shape.default_frr,
        }

        local base = wibox.widget({
            layout           = require("dependencies.overflow").vertical,
            spacing          = dpi(5),
            scrollbar_width  = dpi(8),
            step             = 50,
            scrollbar_widget = scroll,
        })

        local pp = awful.popup {
            widget              = base,
            type                = "dropdown_menu",
            minimum_height      = dpi(300),
            maximum_height      = dpi(800),
            minimum_width       = dpi(150),
            visible             = false,
            ontop               = true,
            hide_on_right_click = false,
            shape               = shape.default_frr,
            placement           = awful.placement.centered,
            bg                  = beautiful.palette_c7
        }

        awesome.connect_signal("update::themes", function()
            base:reset()
            local get_list_cmd = commands.get_text_sorted(cfg.theme.cache_file, 1, 'asc');

            awful.spawn.easy_async_with_shell(get_list_cmd, function(stdout)

                for w in stdout:gmatch("[^\r\n]+") do
                    local arr = nd_utils.split(w, ' ')

                    local theme_name = wibox.widget({
                        widget  = wibox.container.margin,
                        margins = {
                            left  = dpi(15),
                            top   = dpi(5),
                            right = dpi(15),
                            bottom = dpi(5)
                        },
                        {
                            widget = wibox.container.background,
                            bg     = beautiful.palette_c6,
                            shape  = shape_utils.default_frr,
                            {
                                widget  = wibox.container.margin,
                                margins = dpi(10),
                                {
                                    {
                                        image  = arr[2],
                                        forced_height = dpi(170),
                                        forced_width  = dpi(220),
                                        resize = true,
                                        widget = wibox.widget.imagebox
                                    },
                                    {

                                        widget = wibox.widget.textbox,
                                        markup   = "<span foreground='" .. beautiful.palette_c2 .. "'><b>" .. arr[1] .. "</b></span>",
                                        align = 'center',
                                        valign = 'bottom',
                                        font = beautiful.icons_font .. '16',
                                    },
                                    layout = wibox.layout.stack
                                }
                            }
                        }
                    })

                    theme_name:buttons(gears.table.join(awful.button({ }, 1, function()
                        theme_util.switch(arr[1])
                    end)))

                    base:add(theme_name)
                end
            end)
        end)

        icon:connect_signal('button::press', function()
            is_theme_popup_opened = not is_theme_popup_opened
            pp.visible = is_theme_popup_opened
        end)

        return icon
    end
}
