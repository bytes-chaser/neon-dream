local wibox       = require("wibox")
local beautiful   = require("beautiful")
local dpi         = beautiful.xresources.apply_dpi
local shape_utils = require("commons.shape")
local icons       = require("commons.icons")

return {
    create = function(id_text, image_text, name_text, ports_text, status_text, time_text)


        local name = {
            widget = wibox.widget.textbox,
            markup   = "<span foreground='" .. beautiful.fg_focus .."'>" .. name_text .."</span>",
            font = beautiful.font_famaly .. '10',
        }

        local image = {
            widget = wibox.widget.textbox,
            markup   = "<span foreground='" .. beautiful.fg_normal .."'>" .. image_text .."</span>",
            font = beautiful.font_famaly .. '8',
        }

        local id = {
            widget = wibox.widget.textbox,
            markup   = "<span foreground='" .. beautiful.fg_normal .."'>ID: " .. id_text .."</span>",
            font = beautiful.font_famaly .. '10',
        }

        local ports = {
            widget = wibox.widget.textbox,
            markup   = "<span foreground='" .. beautiful.fg_normal .."'>" .. (ports_text == 'Noinfo' and "Unexposed" or ports_text:gsub('@', ' ')) .."</span>",
            font = beautiful.font_famaly .. '10',
        }

        local time = {
            widget = wibox.widget.textbox,
            markup   = "<span foreground='" .. beautiful.fg_normal .."'>Time: " .. time_text:gsub("___", ' ') .."</span>",
            font = beautiful.font_famaly .. '10',
        }

        local status_icon
        local color

        if 'Up' == status_text then
            status_icon = ''
            color = beautiful.palette_positive
        else
            status_icon = ''
            color = beautiful.palette_negative
        end

        local status = icons.wbic(status_icon, 20, color)


        local function horizontal_scroll(w, height)
            return wibox.widget {
                layout = wibox.container.scroll.horizontal,
                forced_height = height,
                step_function = wibox.container.scroll.step_functions
                                     .nonlinear_back_and_forth,
                speed = 50,
                w,
            }
        end

        local function margin(w)
            return {
                w,
                widget = wibox.container.margin,
                left   = dpi(10),
                top    = dpi(5),
            }
        end


        local ratio_box = wibox.widget {
            status,
            {
                margin(horizontal_scroll(name, 45)),
                margin(horizontal_scroll(image)),
                layout = wibox.layout.flex.vertical
            },
            {
                margin(horizontal_scroll(id, 10)),
                margin(horizontal_scroll(time, 10)),
                margin({
                    {
                        widget = wibox.widget.textbox,
                        markup   = "<span foreground='" .. beautiful.fg_normal .."'>Ports: </span>",
                        font = beautiful.font_famaly .. '10',
                    },
                    horizontal_scroll(ports, 10),
                    layout = wibox.layout.fixed.horizontal

                }),
                layout = wibox.layout.flex.vertical
            },
            layout  = wibox.layout.ratio.horizontal
        }

        ratio_box:ajust_ratio(2, 0.1, 0.4, 0.5)


        return {
            {
                {
                    ratio_box,
                    widget = wibox.container.margin,
                    margins = cfg.panels.docker.style.card_margin
                },
                layout = require("dependencies.overflow").vertical,
                spacing = dpi(5),
                scrollbar_widget = {
                    widget = wibox.widget.separator,
                    shape = shape_utils.default_frr,
                },
                scrollbar_width = dpi(8),
                step = 50,
            },
            widget = wibox.container.background,
            bg = beautiful.palette_c7,
        }
    end
}
