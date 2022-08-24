local awful        = require("awful")
local beautiful    = require("beautiful")
local wibox        = require("wibox")
local gears        = require("gears")

return {
    create = function(parent, shape, pos, anch, options)
        local box = {
            layout = wibox.layout.flex.vertical,
        }

        local options_map = {}

        for key, value in pairs(options) do

            local color = value.default and beautiful.pallete_c4 or beautiful.pallete_c2
            local opt = wibox.widget({
                widget = wibox.container.margin,
                margins = {
                    left = 5,
                    right = 10,
                    top = 5,
                    bottom = 5,
                },
                {
                    {
                        widget = wibox.container.margin,
                        margins = 5,
                        {
                            id = value.name,
                            widget = wibox.widget.textbox,
                            markup = "<span foreground='" .. color .."'>" .. value.name .. "</span>"
                        }
                    },
                    widget = wibox.container.background,
                    bg = beautiful.palette_c7
                }
            })

            table.insert(box, opt)
            options_map[value.name] = opt

            opt:buttons(gears.table.join(awful.button({ }, 1, function()

                for ok, ov in pairs(options_map) do
                    local child = ov:get_children_by_id(ok)[1]
                    child.markup = "<span foreground='" ..
                            (ok == value.name and beautiful.pallete_c4 or beautiful.pallete_c2)
                            .."'>" .. ok .. "</span>"
                end

                value.callback(parent, value.name, key)
            end)))
        end

        local droplist = awful.popup {
            widget = box,
            preferred_positions = pos,
            preferred_anchors = {anch},
            ontop = true,
            shape = shape,
            visible = false
        }

        local popup_opened = true

        parent:buttons(gears.table.join(awful.button({ }, 1, function()
            droplist:move_next_to(mouse.current_widget_geometry)
            -- Simple 'p2.visible = not p2.visible' doesn't work by some reason
            droplist.visible = popup_opened
            popup_opened = not popup_opened
        end)))
    end
}