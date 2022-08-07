local wibox       = require("wibox")
local beautiful   = require("beautiful")
local dpi         = beautiful.xresources.apply_dpi

return {
  create = function(package, version, available, color, available_text_font)
    local package_name = {
      widget = wibox.widget.textbox,
      markup   = "<span foreground='" .. beautiful.fg_focus .."'>" .. package .."</span>",
      font = beautiful.font_famaly .. '12',
    }

    local current_version = {
      widget = wibox.widget.textbox,
      markup = "<span foreground='" .. color .."'>" .. version .. "</span>",
      font = beautiful.font_famaly .. '12',
    }

    local available_version = {
      align  = "right",
      widget = wibox.widget.textbox,
      markup = available,
      font = available_text_font,
    }

    return {
      id            = package,
      forced_height = dpi(65),
      widget        = wibox.container.background,
      bg            = beautiful.palette_c7,
      {
        {
          package_name,
          {
            {
               layout        = wibox.container.scroll.horizontal,
               max_size      = 100,
               step_function = wibox.container.scroll.step_functions.nonlinear_back_and_forth,
               speed         = 100,
               current_version,
            },
            {
              widget = wibox.container.background
            },
            {
              layout        = wibox.container.scroll.horizontal,
              max_size      = 100,
              step_function = wibox.container.scroll.step_functions.nonlinear_back_and_forth,
              speed         = 100,
              available_version
            },
            layout = wibox.layout.flex.horizontal,
          },
          layout = wibox.layout.flex.vertical,
        },
        widget  = wibox.container.margin,
        margins = dpi(10)
      }

    }
  end
}
