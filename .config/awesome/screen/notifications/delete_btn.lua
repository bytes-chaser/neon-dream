local awful         = require("awful")
local gears         = require("gears")
local beautiful     = require("beautiful")
local wibox         = require("wibox")
local notif_center  = require("widgets.notification_center")


local delete_all_notif = wibox.widget{
      text   = "Delete All",
      font = beautiful.font,
      align = "center",
      opacity = 1,
      widget = wibox.widget.textbox,
}

delete_all_notif:buttons(gears.table.join(awful.button({ }, 1, function()
  notif_center:reset()
end)))

return delete_all_notif;
