local awful             = require("awful")
local wibox             = require("wibox")
local beautiful         = require("beautiful")
local icons             = require("commons.icons")


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

  local battery_icon_t = awful.tooltip {}
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

  return battery_icon

end

return battery_widget_factory
