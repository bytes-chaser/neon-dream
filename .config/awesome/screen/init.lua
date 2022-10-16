local awful         = require("awful")
local gears         = require("gears")
local beautiful     = require("beautiful")

require("screen.rclick_menu")

local tags    = require("screen.tags")
local tasks   = require("screen.tasks")
local notif   = require("screen.notifications")
local wibar   = require("screen.wibar")

local panels_switch  = require("screen.panels_switch")
local stat_bar       = require("panels.stat_bar")
local dev_bar        = require("panels.dev_bar")
local repos_bar      = require("panels.git_bar")
local docker_bar     = require("panels.docker_bar")
local user_bar       = require("panels.user_bar")


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

    if cfg.panels.stats.enabled then
        s.stats  = stat_bar.create(s)
        panels_switch.add_panel(s, s.stats)
    end

    if cfg.panels.packages.enabled then
        s.pacs  = dev_bar.create(s)
        panels_switch.add_panel(s, s.pacs)
    end

    if cfg.panels.git.enabled then
        s.repos  = repos_bar.create(s)
        panels_switch.add_panel(s, s.repos)
    end

    if cfg.panels.docker.enabled then
        s.docker = docker_bar.create(s)
        panels_switch.add_panel(s, s.docker)
    end

    if cfg.panels.user.enabled then
        s.user   = user_bar.create(s)
        panels_switch.add_panel(s, s.user)
    end

    s.notif  = notif.create(s)
    
    wibar.create(s)

end)
