
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
                titlebar_buttons.create_titlebar_button("", "",
                'maximized',
                function(c)
                    return false
                end,
                function()
                    titlebar_buttons.close(c)
                end),

                titlebar_buttons.create_titlebar_button("", "",
                'maximized',
                function(c)
                    return c.maximized
                end,
                function()
                    titlebar_buttons.maximize(c)
                end),

                titlebar_buttons.create_titlebar_button("", "",
                'floating',
                function(c)
                    return c.floating
                end,
                function()
                    titlebar_buttons.floating(c)
                end),

                titlebar_buttons.create_titlebar_button("", "",
                'sticky',
                function(c)
                    return c.sticky
                end,
                function()
                    titlebar_buttons.sticky(c)
                end),

                titlebar_buttons.create_titlebar_button("", "",
                'ontop',
                function(c)
                    return c.ontop
                end,
                function()
                    titlebar_buttons.ontop(c)
                end),

                layout = wibox.layout.fixed.horizontal,
                spacing = dpi(7)
            },
            {
              buttons = globalkeys,
              font = beautiful.ont,
              align = "center",
              widget = wibox.widget.textbox("")
            },

            widget = wibox.container.margin,
            left = dpi(6),
        },

        { -- Middle
            { -- Title
                layout  = wibox.layout.flex.horizontal
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            layout = wibox.layout.fixed.horizontal
        },
        widget = wibox.container.background,
        buttons = nil
    }

    if show_titlebar then
      awful.titlebar.show(c)
    else
      awful.titlebar.hide(c)
    end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
