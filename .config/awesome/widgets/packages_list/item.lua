local wibox       = require("wibox")
local beautiful   = require("beautiful")
local dpi         = beautiful.xresources.apply_dpi

return {
  create = function(package, c_version, c_color, a_version, a_font, a_color)
    local package_name = {
      widget   = wibox.widget.textbox,
      markup   = "<span foreground='" .. beautiful.fg_focus .."'>" .. package .."</span>",
      font     = beautiful.font_famaly .. '12',
    }

    local current_version = {
      widget = wibox.widget.textbox,
      markup = "<span foreground='" .. c_color .."'>" .. c_version .. "</span>",
      font   = beautiful.font_famaly .. '12',
    }

    local available_version = {
      align  = "right",
      widget = wibox.widget.textbox,
      markup =  "<span foreground='" .. a_color .."'>" .. a_version .. "</span>",
      font   = beautiful.font_famaly .. a_font,
    }

    return {
      id            = package,
      widget        = wibox.container.background,
      bg            = beautiful.palette_c7,
      {
        {
          package_name,
          {
            {
               layout        = wibox.container.scroll.horizontal,
               forced_height = 25,
               step_function = wibox.container.scroll.step_functions.nonlinear_back_and_forth,
               speed         = 100,
               current_version,
            },
            {
              widget = wibox.container.background
            },
            {
              layout        = wibox.container.scroll.horizontal,
              forced_height = 25,
              step_function = wibox.container.scroll.step_functions.nonlinear_back_and_forth,
              speed         = 100,
              available_version
            },
            layout = wibox.layout.flex.horizontal,
          },
          layout = wibox.layout.flex.vertical,
        },
        widget  = wibox.container.margin,
        margins = dpi(cfg.panels.packages.style.card_margin)
      }

    }
  end
}
