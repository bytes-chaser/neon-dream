
local awful       = require("awful")
local wibox       = require("wibox")
local beautiful   = require("beautiful")
local gears       = require("gears")
local icons       = require("commons.icons")
local dpi         = beautiful.xresources.apply_dpi

local tittlebar_buttons = {}

tittlebar_buttons.close = function(c)
    c:kill()
end

tittlebar_buttons.maximize = function(c)
    c.maximized = not c.maximized c:raise()
end

tittlebar_buttons.floating = function(c)
    awful.client.floating.toggle(c)
end


tittlebar_buttons.create_titlebar_button = function(c, init_icon, focus_icon, command) 
    local btn = wibox.widget{
        icons.wbifo(init_icon, 12, 0, 0.5),
        forced_width = dpi(24),
        forced_height = dpi(24),
        shape = gears.shape.circle,
        bg     = beautiful.titlebar_button_color,
        widget = wibox.container.background
    }

    btn:connect_signal('mouse::enter', function ()
        btn.bg = beautiful.titlebar_button_color .. "4D"
    end)

    btn:connect_signal('mouse::leave', function ()
        btn.bg = beautiful.titlebar_button_color
      end)

    btn:connect_signal('button::release', function ()
        btn.bg = beautiful.titlebar_button_color
    end)

    btn:buttons(gears.table.join(
        awful.button({ }, 1, command)))

    return btn
end

return tittlebar_buttons