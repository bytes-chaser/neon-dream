local awful          = require("awful")
local beautiful      = require("beautiful")
local wibox          = require("wibox")
local bwf            = require("widgets.battery")
local dpi            = beautiful.xresources.apply_dpi
local shape_utils    = require("commons.shape")
local wbm            = require("widgets.wibar_monitor")
local wb_player      = require("widgets.player.wibar")
local ts             = require("widgets.theme_switch")
local notifi         = require("screen.notif_icon")
local panels_switch  = require("screen.panels_switch")


return {
  create = function(s)

    local notif_icon = notifi.create(s)

    local wbm_cpu = wbm.create("CPU: ")
    awesome.connect_signal("sysstat::cpu", function(val, postfix)
        wbm_cpu.wbm_body.wbm_labels.wbm_valtext.text = val .. postfix
        wbm_cpu.wbm_body.wbm_graphs_margin.wbm_graphs.wbm_graph:add_value(val, 1)
    end)

    local cpu_section = {
      widget = wibox.container.background,
      bg = beautiful.palette_c3,
      shape = shape_utils.default_frr,
      wbm_cpu
    }

    local wbm_ram = wbm.create("RAM: ")
    awesome.connect_signal("sysstat::ram", function(val, postfix)
        wbm_ram.wbm_body.wbm_labels.wbm_valtext.text = val .. postfix
        wbm_ram.wbm_body.wbm_labels.wbm_valtext.text = val .. postfix
        wbm_ram.wbm_body.wbm_graphs_margin.wbm_graphs.wbm_graph:add_value(val, 1)
    end)

    local ram_section = {
      widget = wibox.container.background,
      bg = beautiful.palette_c3,
      shape = shape_utils.default_frr,
      wbm_ram
    }

    local wibar = awful.wibar({

      position = "top",
      screen   = s,
      bg       = beautiful.col_transparent,
      height   = dpi(40)
    })

    wibar:setup {
        widget = wibox.container.margin,
        top    = dpi(4),
        left   = dpi(7),
        right  = dpi(7),
        {
          layout = wibox.layout.align.horizontal,
          { -- Left widgets
              layout = wibox.layout.fixed.horizontal,
              {
                widget = wibox.container.background,
                bg     = beautiful.palette_c3,
                shape  = shape_utils.default_frr,
                {
                  layout = wibox.layout.fixed.horizontal,
                  s.mytaglist,
                },
              },
              {
                widget = wibox.container.margin,
                left   = dpi(10),
                {
                  widget = wibox.container.background,
                  bg     = beautiful.palette_c3,
                  shape  = shape_utils.default_frr,
                  {
                    widget = wibox.container.margin,
                    left   = dpi(10),
                    right  = dpi(10),
                    panels_switch.create(s)
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
                  widget  = wibox.container.background,
                  bg      = beautiful.palette_c3,
                  shape   = shape_utils.default_frr,
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
                  bg = beautiful.palette_c3,
                  shape = shape_utils.default_frr,
                  wb_player
                }
              },
              {
                widget = wibox.container.margin,
                right = dpi(10),
                cpu_section
              },
              {
                widget = wibox.container.margin,
                right = dpi(10),
                ram_section
              },
              {
                widget = wibox.container.background,
                bg     = beautiful.palette_c3,
                shape  = shape_utils.default_frr,
                {
                  layout = wibox.layout.fixed.horizontal,
                  wibox.widget.textclock(),
                  bwf.create({size = 20}),
                  {
                      createWidget(ts, {size = 12}),
                      margins = 10,
                      widget  = wibox.container.margin
                  },
                  {
                    notif_icon,
                    margins = 10,
                    widget  = wibox.container.margin
                  },
                  awful.widget.keyboardlayout(),
                  wibox.widget.systray(),
                  -- s.mylayoutbox,
                }
              }
          }
        }
    }

    return wibar

  end
}
