-- Widget for wheather indication

local awful       = require("awful")
local wibox       = require("wibox")
local beautiful   = require("beautiful")
local dpi         = beautiful.xresources.apply_dpi
local icons       = require("commons.icons")

require("config.weather")

return {
  create = function()

    local icon = icons.wbic('', '30', beautiful.pallete_c1)
    local temp_txt = wibox.widget({
        widget = wibox.widget.textbox,
        text = '0',
        font = beautiful.font_famaly .. '26'

    })

    local base_widget = wibox.widget({
      {
        icon,
        widget = wibox.container.margin,
        right = dpi(10)
      },
      temp_txt,
      layout = wibox.layout.fixed.horizontal
    })


    awesome.connect_signal("data:weather", function(status, t)
        local weather_icon = ''
        local weather_text = 'No Data'

        if status ~= nil then
          weather_text = t .. '°'
          weather_icon = weather_icons_map[tonumber(status)]
        end

        icon.markup =  "<span foreground='" .. beautiful.pallete_c1 .."'>" .. weather_icon .. "</span>"
        temp_txt.text = weather_text
    end)

    return base_widget

  end
}
