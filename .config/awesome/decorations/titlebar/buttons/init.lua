
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
    c.floating = not c.floating
end

tittlebar_buttons.sticky = function(c)
    c.sticky = not c.sticky
end

tittlebar_buttons.ontop = function(c)
    c.ontop = not c.ontop
end


tittlebar_buttons.create_titlebar_button = function(init_icon, active_icon, property, conditionF, command)
    local icon = icons.wbicc(icons.wbifo(icons.wbi(init_icon, 12), 0, 1), active_icon, property, conditionF)
    local btn = wibox.widget{
        icon,
        forced_width    = dpi(24),
        forced_height   = dpi(24),
        shape           = gears.shape.circle,
        bg              = beautiful.bg_urgent,
        widget          = wibox.container.background
    }

    btn:connect_signal('mouse::enter', function ()
        btn.bg = beautiful.bg_urgent .. "9D"
    end)

    btn:connect_signal('mouse::leave', function ()
        btn.bg = beautiful.bg_urgent
      end)

    btn:connect_signal('button::fg_normal', function ()
        btn.bg = beautiful.bg_urgent
    end)

    btn:buttons(gears.table.join(
        awful.button({ }, 1, command)))

    return btn
end

return tittlebar_buttons
