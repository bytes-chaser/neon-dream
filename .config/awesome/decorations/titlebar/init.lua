
local awful             = require("awful")
local wibox             = require("wibox")
local beautiful         = require("beautiful")
local gears             = require("gears")
local dpi               = beautiful.xresources.apply_dpi
local shape_utils       = require("commons.shape")
local titlebar_buttons  = require("decorations.titlebar.buttons")


-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    


    awful.titlebar(c, { position = "top", size = dpi(36)}) : setup {
        layout = wibox.layout.align.horizontal,
        { -- Left
            {
                titlebar_buttons.create_titlebar_button(c, "", "",
                function()
                    titlebar_buttons.close(c)
                end),
                titlebar_buttons.create_titlebar_button(c, "", "",
                function()
                    titlebar_buttons.maximize(c)
                end),
                titlebar_buttons.create_titlebar_button(c, "", "",
                 function()
                    titlebar_buttons.floating(c)
                end),
                layout = wibox.layout.fixed.horizontal,
                spacing = dpi(7)
            },
            
            widget = wibox.container.margin,
            left = dpi(6),
        },
        
        { -- Middle
            { -- Title
            
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal
        },
        widget = wibox.container.background,
        buttons = nil
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
