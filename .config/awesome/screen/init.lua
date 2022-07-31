local awful         = require("awful")
local gears         = require("gears")
local beautiful     = require("beautiful")
local menubar       = require("menubar")
local wibox         = require("wibox")
local hotkeys_popup = require("awful.hotkeys_popup")
local bwf           = require("widgets.battery")
local dpi           = beautiful.xresources.apply_dpi
local shape_utils   = require("commons.shape")
local icons         = require("commons.icons")
local wbm           = require("widgets.wibar_monitor")
local wb_player     = require("widgets.wibar_player")
local naughty       = require("naughty")
local notif_center  = require("widgets.notification_center")


-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
    { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
    { "manual", terminal .. " -e man awesome" },
    { "edit config", editor_cmd .. " " .. awesome.conffile },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end },
 }

 mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                     { "open terminal", terminal }
                                   }
                         })

 mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                      menu = mymainmenu })

 -- Menubar configuration
 menubar.utils.terminal = terminal -- Set the terminal for applications that require it
 -- }}}

 -- Keyboard map indicator and switcher
 mykeyboardlayout = awful.widget.keyboardlayout()

 -- {{{ Wibar
 -- Create a textclock widget
 mytextclock = wibox.widget.textclock()

 -- Create a wibox for each screen and add it
 local taglist_buttons = gears.table.join(
                     awful.button({ }, 1, function(t) t:view_only() end),
                     awful.button({ modkey }, 1, function(t)
                                               if client.focus then
                                                   client.focus:move_to_tag(t)
                                               end
                                           end),
                     awful.button({ }, 3, awful.tag.viewtoggle),
                     awful.button({ modkey }, 3, function(t)
                                               if client.focus then
                                                   client.focus:toggle_tag(t)
                                               end
                                           end),
                     awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                     awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                 )

 local tasklist_buttons = gears.table.join(
                      awful.button({ }, 1, function (c)
                                               if c == client.focus then
                                                   c.minimized = true
                                               else
                                                   c:emit_signal(
                                                       "request::activate",
                                                       "tasklist",
                                                       {raise = true}
                                                   )
                                               end
                                           end),
                      awful.button({ }, 3, function()
                                               awful.menu.client_list({ theme = { width = 250 } })
                                           end),
                      awful.button({ }, 4, function ()
                                               awful.client.focus.byidx(1)
                                           end),
                      awful.button({ }, 5, function ()
                                               awful.client.focus.byidx(-1)
                                           end))



local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag(cfg.tags, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        layout = {spacing = dpi(10), layout = wibox.layout.fixed.horizontal},
        widget_template = {
          {
            {
              {
                  {
                    {
                        id     = 'text_role',
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                  },
                  margins = dpi(8),
                  widget = wibox.container.margin
              },

              bg = beautiful.palette_c7,
              shape  = cfg.tags_shape,
              widget = wibox.container.background
            },
            margins  = {
              top = 5,
              bottom  = 5,
              left = 6,
              right = 6,
            },
            widget = wibox.container.margin
          },
          id     = 'background_role',
          widget = wibox.container.background,
        }
    }

    -- Create a tasklist widget
    s.focused_task = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.focused,
        buttons = tasklist_buttons,
        widget_template = {
        {
          {
            layout = wibox.container.scroll.horizontal,
            max_size = 400,
            step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
            speed = 300,
            {
                id     = 'text_role',
                widget = wibox.widget.textbox,
                align  = 'center',
                valign = 'center',
            }
          },
          left  = 10,
          right = 10,
          widget = wibox.container.margin
        },
        shape = shape_utils.partially_rounded_rect(beautiful.rounded, true, true, true, true),
        widget = wibox.container.background,
      }
    }

    -- Create the wibox
    s.mywibox = awful.wibar({
      position = "top",
      screen = s,
      bg = beautiful.col_transparent,
      height = dpi(40)
    })


    local wbm_cpu = wbm.create("CPU: ")
    awesome.connect_signal("sysstat::cpu", function(cpu_val)
        wbm_cpu.wbm_body.wbm_labels.wbm_valtext.text = cpu_val .. '%'
        wbm_cpu.wbm_body.wbm_graphs_margin.wbm_graphs.wbm_graph:add_value(cpu_val, 1)
    end)

    local wbm_ram = wbm.create("RAM: ")
    awesome.connect_signal("sysstat::ram", function(used, total)
        local label_val = math.floor(100 * (used / total))
        wbm_ram.wbm_body.wbm_labels.wbm_valtext.text = label_val .. '%'
        wbm_ram.wbm_body.wbm_graphs_margin.wbm_graphs.wbm_graph:add_value(label_val, 1)
    end)



    s.notif = awful.wibar {
        position = "right",
        screen   = s,
        width    = dpi(400),
        height = dpi(1000),
        margins = {
          top = dpi(20),
          right = dpi(10)
        },
        visible = false
    }


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

    s.notif:setup {
      layout = wibox.layout.fixed.vertical,
      {
        bg = beautiful.palette_c7,
        widget = wibox.container.background,
        {
          widget = wibox.container.margin,
          margins = dpi(10),
          {
                markup   = "<span foreground='" .. beautiful.fg_focus .."'>Notifications</span>",
                font = beautiful.font_famaly .. '20',
                align = "center",
                opacity = 1,
                widget = wibox.widget.textbox,
          }
        },
      },
      delete_all_notif,
      notif_center
    }

    local notif_icon = icons.wbi("", 14)

    local notif_icon_box = {
      notif_icon,
      margins = 10,
      widget  = wibox.container.margin
    },

    notif_icon:buttons(gears.table.join(awful.button({ }, 1, function()
      s.notif.visible = not s.notif.visible
    end)))

   -- s.notif:bind_to_widget(notif_icon)
   local create_munu_panel_button = function(glyph, text, btn_fn)
     local btn = wibox.widget{
         {
           {
             icons.wbi(glyph, 12),
             margins = dpi(5),
             widget = wibox.container.margin
           },
           bg = beautiful.palette_c7,
           widget = wibox.container.background
         },
         margins = dpi(5),
         widget = wibox.container.margin

     }

     local myclock_t = awful.tooltip {
         objects        = { btn },
         timer_function = function()
             return text
         end,
     }

     btn_fn(btn)
     return btn
   end


   show_sub_panel = false
   sub_panel_mode = 'dev'

   local stat_bar = require("widgets.stat_bar")
   stat_bar.create(s)

   local dev_bar = require("widgets.dev_bar")
   dev_bar.create(s)

   local user_bar = require("widgets.user_bar")
   user_bar.create(s)

   local close_all_sub_panels = function()
     s.stats.visible    = false
     s.dev.visible = false
     s.user.visible     = false
   end


    -- Add widgets to the wibox
    s.mywibox:setup {
        widget = wibox.container.margin,
        top =  dpi(4),
        left = dpi(7),
        right = dpi(7),
        {
          layout = wibox.layout.align.horizontal,
          { -- Left widgets
              layout = wibox.layout.fixed.horizontal,
              {
                widget = wibox.container.background,
                bg = beautiful.pallete_c3,
                shape = shape_utils.partially_rounded_rect(beautiful.rounded, true, true, true, true),
                {
                  layout = wibox.layout.fixed.horizontal,
                  s.mytaglist,
                  -- s.mypromptbox,
                },
              },
              {
                widget = wibox.container.margin,
                left = dpi(10),
                {
                  widget = wibox.container.background,
                  bg = beautiful.pallete_c3,
                  shape = shape_utils.partially_rounded_rect(beautiful.rounded, true, true, true, true),
                  {
                    widget = wibox.container.margin,
                    left = dpi(10),
                    right = dpi(10),
                    {
                      layout = wibox.layout.fixed.horizontal,


                      create_munu_panel_button("", "User", function(btn)
                        btn:buttons(gears.table.join(awful.button({ }, 1, function()
                          if sub_panel_mode == 'user' and show_sub_panel then
                            s.user.visible = false
                            show_sub_panel = false
                          else
                            if not sub_panel_mode ~= 'user' then
                              close_all_sub_panels()
                            end
                            show_sub_panel = true
                            sub_panel_mode = 'user'
                            s.user.visible = true

                          end
                        end)))
                      end),
                      create_munu_panel_button("", "Devtools", function(btn)
                        btn:buttons(gears.table.join(awful.button({ }, 1, function()
                          if sub_panel_mode == 'dev' and show_sub_panel then
                            s.dev.visible = false
                            show_sub_panel = false
                          else
                            if not sub_panel_mode ~= 'dev' then
                              close_all_sub_panels()
                            end
                            show_sub_panel = true
                            sub_panel_mode = 'dev'
                            s.dev.visible = true

                          end
                        end)))
                      end),

                      create_munu_panel_button("", "Stats", function(btn)
                        btn:buttons(gears.table.join(awful.button({ }, 1, function()
                          if sub_panel_mode == 'stat' and show_sub_panel then
                            s.stats.visible = false
                            show_sub_panel = false
                          else
                            if not sub_panel_mode ~= 'stat' then
                              close_all_sub_panels()
                            end
                            show_sub_panel = true
                            sub_panel_mode = 'stat'
                            s.stats.visible = true

                          end
                        end)))
                      end),
                    }
                  }
                }
              },
              {
                widget = wibox.container.margin,
                left = dpi(10),
                {
                  {
                    layout = wibox.layout.fixed.horizontal,
                    s.focused_task,
                  },
                  widget = wibox.container.background,
                  bg = beautiful.pallete_c3,
                  shape = shape_utils.partially_rounded_rect(beautiful.rounded, true, true, true, true),
                }
              }
          },
          nil,
          { -- Right widgets
              layout = wibox.layout.fixed.horizontal,
              {
                widget = wibox.container.margin,
                right = dpi(10),
                {
                  widget = wibox.container.background,
                  bg = beautiful.pallete_c3,
                  shape = shape_utils.partially_rounded_rect(beautiful.rounded, true, true, true, true),
                  wb_player
                }
              },
              {
                widget = wibox.container.margin,
                right = dpi(10),
                {
                  widget = wibox.container.background,
                  bg = beautiful.pallete_c3,
                  shape = shape_utils.partially_rounded_rect(beautiful.rounded, true, true, true, true),
                  wbm_cpu
                }
              },
              {
                widget = wibox.container.margin,
                right = dpi(10),
                {
                  widget = wibox.container.background,
                  bg = beautiful.pallete_c3,
                  shape = shape_utils.partially_rounded_rect(beautiful.rounded, true, true, true, true),
                  wbm_ram
                }
              },
              {
                widget = wibox.container.background,
                bg = beautiful.pallete_c3,
                shape = shape_utils.partially_rounded_rect(beautiful.rounded, true, true, true, true),
                {
                  layout = wibox.layout.fixed.horizontal,
                  mytextclock,
                  bwf.create({size = 20}),
                  notif_icon_box,
                  mykeyboardlayout,
                  wibox.widget.systray(),
                  -- s.mylayoutbox,
                }
              }
          }
        }
    }

end)
-- }}}
