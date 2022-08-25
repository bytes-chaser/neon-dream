local awful     = require("awful")
local beautiful = require("beautiful")
local gears     = require("gears")
local wibox     = require("wibox")
local icons     = require("commons.icons")

return {
    create = function(font, prev_cb, next_cb)

        local prev = icons.wbi('', 20)
        local next = icons.wbi('', 20)

        prev:buttons(gears.table.join(awful.button({ }, 1, prev_cb)))
        next:buttons(gears.table.join(awful.button({ }, 1, next_cb)))

        return wibox.widget({
            layout = wibox.layout.fixed.vertical,
            spacing = 5,
            {
                id = 'text_header',
                layout = wibox.layout.fixed.horizontal,
                spacing = 5,
                {
                    id = 'element_start_num',
                    widget = wibox.widget.textbox,
                    text = '0',
                    align = "center",
                    font = beautiful.icons_font .. tostring(font),
                },
                {
                    widget = wibox.widget.textbox,
                    text = '-',
                    align = "center",
                    font = beautiful.icons_font .. tostring(font),
                },
                {
                    id = 'element_end_num',
                    widget = wibox.widget.textbox,
                    text = '0',
                    align = "center",
                    font = beautiful.icons_font .. tostring(font),
                },
                {
                    widget = wibox.widget.textbox,
                    text = ' of ',
                    align = "center",
                    font = beautiful.icons_font .. tostring(font),
                },
                {
                    id = 'element_total_num',
                    widget = wibox.widget.textbox,
                    text = '0',
                    align = "center",
                    font = beautiful.icons_font .. tostring(font),
                },
            },
            {
                id = 'page_switch',
                layout = wibox.layout.fixed.horizontal,
                spacing = 5,
                prev,
                {
                    id = 'page_num',
                    widget = wibox.widget.textbox,
                    text = '0',
                    font = beautiful.icons_font .. tostring(font),
                },
                {
                    widget = wibox.widget.textbox,
                    text = '/',
                    font = beautiful.icons_font .. tostring(font),
                },
                {
                    id = 'page_total',
                    widget = wibox.widget.textbox,
                    text = '0',
                    font = beautiful.icons_font .. tostring(font),
                },
                next,
            }

        })

    end,

    update = function(paginator, page, size, totalElements, totalPages)
        local end_num = page * size
        end_num = end_num > totalElements and totalElements or end_num

        paginator.text_header.element_start_num.text   = tostring(((page - 1) * size) + 1)
        paginator.text_header.element_end_num.text     = tostring(end_num)
        paginator.text_header.element_total_num.text   = tostring(totalElements)

        paginator.page_switch.page_num.text     = tostring(page)
        paginator.page_switch.page_total.text   = tostring(totalPages)
    end
}