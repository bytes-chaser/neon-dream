local awful             = require("awful")
local wibox             = require("wibox")
local beautiful         = require("beautiful")
local dpi               = beautiful.xresources.apply_dpi
local icons             = require("commons.icons")
local commands          = require("commons.commands")
local shape             = require("commons.shape")

local es                = require("widgets.battery.exit")

is_power_popup_opened = false

return {
  create = function(parameters)

    local value = 0

    local battery_icon = wibox.widget{
        text    = "",
        align   = parameters.alignment or beautiful.battery_aligment,
        opacity = parameters.opacity   or beautiful.battery_opacity,
        font    = beautiful.icons_font .. (parameters.size or beautiful.battery_size),
        widget  = wibox.widget.textbox,
    }

    local battery_icon_t = awful.tooltip {
      ontop = true,
      mode  = 'mouse'
    }

    battery_icon_t:add_to_object(battery_icon)
    battery_icon:connect_signal('mouse::enter', function()
      battery_icon_t.text = tostring(value) .. "%"
    end)

    awesome.connect_signal("sysstat::pow", function(pow_val, postfix, status)
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
      widget              = es.create(),
      type                = "dropdown_menu",
      minimum_height      = dpi(1500),
      minimum_width       = dpi(2000),
      border_width        = 5,
      visible             = false,
      ontop               = true,
      hide_on_right_click = true,
      shape               = shape.default_frr,
      placement           = awful.placement.centered,
      bg                  = beautiful.col_transparent
    }

    battery_icon:connect_signal('button::press', function()
      is_power_popup_opened = not is_power_popup_opened
      pp.visible = is_power_popup_opened
    end)

    return battery_icon

  end
}
