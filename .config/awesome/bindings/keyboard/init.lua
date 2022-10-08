local gears         = require("gears")
local awful         = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local beautiful     = require("beautiful")
local naughty       = require("naughty")

local close_all_sub_panels = function(s)
  s.stats.visible    = false
  s.pacs.visible = false
  s.repos.visible = false
  s.docker.visible = false
  s.user.visible     = false
end
-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function ()
      awful.layout.inc( 1)
      naughty.notify({
                       title = "Layout Change",
                       text = tostring(awful.layout.getname()) })
                    end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function ()
      awful.layout.inc(-1)
      naughty.notify({
                       title = "Layout Change",
                       text = tostring(awful.layout.getname()) })
    end,
              {description = "select previous", group = "layout"}),
    awful.key({ modkey }, "t", function ()
                      local c = client.focus
                      if c then
                        awful.titlebar.toggle(c)
                      end
                   end,
              {description = "focused client titlebar visibility toggle", group = "layout"}),

  awful.key({ modkey, "Shift" }, "t", function ()
                    for _, c in ipairs(client.get()) do
                        awful.titlebar.toggle(c)
                    end
                    show_titlebar = not show_titlebar
                 end,
            {description = "all clients titlebar visibility toggle", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),




    awful.key({ modkey, "Shift" },  "u",     function ()
      local screen = awful.screen.focused()
      close_all_sub_panels(screen)
      screen.user.visible = not screen.user.visible
    end, {description = "open user wiabar", group = "wibars"}),

    awful.key({ modkey, "Shift" },  "d",     function ()
      local screen = awful.screen.focused()
      close_all_sub_panels(screen)
      screen.docker.visible = not screen.docker.visible
    end, {description = "open docker wibar", group = "wibars"}),

    awful.key({ modkey, "Shift" },  "g",     function ()
        local screen = awful.screen.focused()
        close_all_sub_panels(screen)
        screen.repos.visible = not screen.repos.visible
    end, {description = "open repos wibar", group = "wibars"}),

    awful.key({ modkey, "Shift" },  "z",     function ()
        local screen = awful.screen.focused()
        close_all_sub_panels(screen)
        screen.pacs.visible = not screen.pacs.visible
    end, {description = "open packages wibar", group = "wibars"}),

    awful.key({ modkey, "Shift" },  "s",     function ()
      local screen = awful.screen.focused()
      close_all_sub_panels(screen)
      screen.stats.visible = not screen.stats.visible
    end,{description = "open statistics wibar", group = "wibars"}),

    awful.key({ modkey, "Shift" },  "x",     function ()
      local screen = awful.screen.focused()
      close_all_sub_panels(screen)
    end,{description = "close wibar", group = "wibars"}),
    -- Rofi Run
    awful.key({ modkey },  "r",     function () awful.util.spawn("rofi -show drun") end,
              {description = "open rofi run", group = "launcher"}),

    -- Rofi Window
    awful.key({ "Control" },  "Tab",     function () awful.util.spawn("rofi -show window") end,
               {description = "open rofi window", group = "launcher"}),

      awful.key({ modkey }, "p", function () awful.util.spawn("flameshot screen") end,
      {description = "screenshot", group = "runners"})
)

-- Set keys
root.keys(globalkeys)
