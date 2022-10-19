local dpi     = require("beautiful").xresources.apply_dpi
local ruled   = require("ruled")
local gears   = require("gears")
local naughty = require("naughty")
local wibox   = require("wibox")

ruled.notification.connect_signal("request::rules", function()
    -- Add a red background for urgent notifications.
    ruled.notification.append_rule {
        rule       = { app_name = "Spotify" }, -- Match everything.
        properties = {
            bg ="#FF0000",
            timeout = 10
        }
    }
end)