local awful             = require("awful")
local gears             = require("gears")
local wibox             = require("wibox")
local beautiful         = require("beautiful")
local dpi               = beautiful.xresources.apply_dpi
local icons             = require("commons.icons")
local commands          = require("commons.commands")

is_power_popup_opened = false

local create_btn_container = function(glyph, tooltip, cmd)
  local btn = wibox.widget{
    {
      icons.wbic(glyph, 150, beautiful.pallete_c1),
      margins = 10,
      widget  = wibox.container.margin
    },
    widget  = wibox.container.background,
    shape              = gears.shape.rounded_rect,
    bg                 = beautiful.col_transparent,
    shape_border_color = beautiful.pallete_c1,
    shape_border_width = 10,

  }


  if cmd then
    btn:connect_signal('button::press', function()
      awful.spawn.with_shell(cmd)
    end)
  end



  return {
      btn,
      margins = 10,
      widget  = wibox.container.margin
  }
end



battery_widget_factory = {}
battery_widget_factory.create = function(parameters)
  local value = 0
  local battery_icon = wibox.widget{
      text    = "",
      align   = parameters.alignment or beautiful.battery_aligment,
      opacity = parameters.opacity or beautiful.battery_opacity,
      font    = beautiful.icons_font .. (parameters.size or beautiful.battery_size),
      widget  = wibox.widget.textbox,
  }

  local battery_icon_t = awful.tooltip {
    ontop = true,
    mode = 'mouse'
  }
  battery_icon_t:add_to_object(battery_icon)
  battery_icon:connect_signal('mouse::enter', function()
    battery_icon_t.text = tostring(value) .. "%"
  end)

  awesome.connect_signal("sysstat::pow", function(pow_val, status)
      value = pow_val
      if status:match("Charging") then
        battery_icon.text = ""
      elseif pow_val > 75 then
        battery_icon.text = ""
      elseif pow_val > 50 then
        battery_icon.text = ""
      elseif pow_val > 25 then
        battery_icon.text = ""
      else
        battery_icon.text = ""
      end
  end)


  local pp = awful.popup {
    widget = {
        {
          {
              create_btn_container("", "Shutdown", commands.shutdown),
              create_btn_container("", "Reboot", commands.reboot),
              layout = wibox.layout.fixed.horizontal,
          },
          layout = wibox.container.place,
          valign = 'center',
          halign = 'center'
        },
        margins = 10,
        widget  = wibox.container.margin
    },
    type = "dropdown_menu",
     minimum_height  = dpi(1500),
     minimum_width  = dpi(2000),
    border_width = 5,
    visible = false,
    ontop = true,
    hide_on_right_click = true,
    shape = gears.shape.rounded_rect,
    placement = awful.placement.centered,
    bg = beautiful.col_transparent
  }

  battery_icon:connect_signal('button::press', function()
    is_power_popup_opened = not is_power_popup_opened
    pp.visible = is_power_popup_opened
  end)

  return battery_icon

end

return battery_widget_factory
