local awful             = require("awful")
local wibox             = require("wibox")
local beautiful         = require("beautiful")
local icons             = require("commons.icons")
local commands          = require("commons.commands")
local shape             = require("commons.shape")

local create_btn_container = function(glyph, tooltip, cmd)

  local icon = {
    icons.wbic(glyph, 150, beautiful.pallete_c1),
    margins = 10,
    widget  = wibox.container.margin
  }

  local btn = wibox.widget{
    icon,
    widget             = wibox.container.background,
    shape              = shape.default_frr,
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


return {
  create = function()
    return {
      margins = 10,
      widget  = wibox.container.margin,
      {
          create_btn_container("", "Shutdown", commands.shutdown),
          create_btn_container("", "Reboot", commands.reboot),
          layout = wibox.layout.fixed.horizontal,
      },
      layout = wibox.container.place,
      valign = 'center',
      halign = 'center'
    }
  end
}
