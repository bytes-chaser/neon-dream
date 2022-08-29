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

        local get_list_cmd = commands.get_files(theme_folder)

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
            minimum_width       = dpi(150),
            visible             = false,
            ontop               = true,
            hide_on_right_click = true,
            shape               = shape.default_frr,
            placement           = awful.placement.centered,
            bg                  = beautiful.palette_c7
        }

        icon:connect_signal('button::press', function()
            is_theme_popup_opened = not is_theme_popup_opened
            pp.visible = is_theme_popup_opened
            base:reset()
            awful.spawn.easy_async_with_shell(get_list_cmd, function(stdout)
                for w in stdout:gmatch("[^\r\n]+") do

                    local theme_name = wibox.widget({
                        widget  = wibox.container.margin,
                        margins = {
                            left  = dpi(15),
                            top   = dpi(5),
                            right = dpi(15),
                        },
                        {
                            widget = wibox.container.background,
                            bg     = beautiful.palette_c6,
                            shape  = shape_utils.default_frr,
                            {
                                widget  = wibox.container.margin,
                                margins = dpi(10),
                                {
                                    widget = wibox.widget.textbox,
                                    text = w,
                                    align = 'center'
                                }
                            }
                        }
                    })

                    theme_name:buttons(gears.table.join(awful.button({ }, 1, function()
                        theme_util.switch(w)
                    end)))

                    base:add(theme_name)
                end
            end)

        end)

        return icon
    end
}
