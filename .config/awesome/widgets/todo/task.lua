local beautiful   = require("beautiful")
local dpi         = beautiful.xresources.apply_dpi
local wibox       = require("wibox")

return {

  create = function(text, delete_btn)
    local text_area = {
      widget       = wibox.widget.textbox,
      text         = text,
      font         = beautiful.font_famaly .. '10',
      forced_width = dpi(450)
    }

    local delete_btn_area = {
      delete_btn,
      layout = wibox.layout.fixed.horizontal
    }

    return wibox.widget({
      {
        widget  = wibox.container.margin,
        margins = dpi(10),
        {
          text_area,
          nil,
          delete_btn_area,
          layout = wibox.layout.align.horizontal
        }
      },
      widget = wibox.container.background,
      bg = beautiful.pallete_c3 .. '77'
    })
  end
}
