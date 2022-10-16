-- Widget for whether indication

local wibox       = require("wibox")
local beautiful   = require("beautiful")
local dpi         = beautiful.xresources.apply_dpi
local icons       = require("commons.icons")

require("config.weather")

return {
  name = "weather",
  watchdogs = {
      {
          command = 'curl https://api.weatherapi.com/v1/current.json?key='
                  .. os.getenv("WEATHER_API_COM_API_KEY")
                  .. '&q='.. os.getenv("WEATHER_API_COM_CITY") ..'&aqi=no',
          interval = 200,
          callback = function(widget, stdout)
              local status = stdout:match('code":([0-9]+)},"wind_mph')
              local temperature = stdout:match('temp_c":(.+),"temp_f')
              awesome.emit_signal("data:weather", status, temperature)
          end
      }
  },
  create = function()

    local icon = icons.wbic('', '30', beautiful.palette_c1)
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

        icon.markup =  "<span foreground='" .. beautiful.palette_c1 .."'>" .. weather_icon .. "</span>"
        temp_txt.text = weather_text
    end)

    return base_widget

  end
}
