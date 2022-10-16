local awful         = require("awful")
local gears         = require("gears")
local beautiful     = require("beautiful")

require("screen.rclick_menu")

local tags    = require("screen.tags")
local tasks   = require("screen.tasks")
local notif   = require("screen.notifications")
local wibar   = require("screen.wibar")

local stat_bar    = require("widgets.stat_bar")
local dev_bar     = require("widgets.dev_bar")
local repos_bar   = require("widgets.git_bar")
local docker_bar  = require("widgets.docker_bar")
local user_bar    = require("widgets.user_bar")


local function set_wallpaper(s)
    gears.wallpaper.maximized( beautiful.wallpaper, s, true)
end


screen.connect_signal("property::geometry", set_wallpaper)


awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)

    awful.tag(cfg.tags.names, s, awful.layout.layouts[1])


    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))

    s.mytaglist = tags.create(s)
    s.focused_task = tasks.create(s)

    show_sub_panel = false
    sub_panel_mode = 'user'

    s.stats  = stat_bar.create(s)
    s.pacs   = dev_bar.create(s)
    s.repos  = repos_bar.create(s)
    s.docker = docker_bar.create(s)
    s.user   = user_bar.create(s)
    s.notif  = notif.create(s)
    
    wibar.create(s)

end)
