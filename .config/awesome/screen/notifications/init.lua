local awful         = require("awful")
local gears         = require("gears")
local beautiful     = require("beautiful")
local wibox         = require("wibox")
local dpi           = beautiful.xresources.apply_dpi
local notif_center  = require("widgets.notification_center")
local delete_btn    = require("screen.notifications.delete_btn")

return {

  create = function(s)

    local notif  = awful.wibar {
      
        position = "right",
        screen   = s,
        width    = dpi(400),
        height   = dpi(1000),
        visible  = false,

        margins  = {
          top    = dpi(20),
          right  = dpi(10)
        },
    }


    local header = {
      widget  = wibox.container.margin,
      margins = dpi(10),
      {
            markup   = "<span foreground='" .. beautiful.fg_focus .."'>Notifications</span>",
            font     = beautiful.font_famaly .. '20',
            align    = "center",
            opacity  = 1,
            widget   = wibox.widget.textbox,
      }
    }


    notif:setup {
      layout = wibox.layout.fixed.vertical,
      {
        bg     = beautiful.palette_c7,
        widget = wibox.container.background,
        header,
      },
      delete_btn,
      notif_center
    }

    return notif


  end
}
