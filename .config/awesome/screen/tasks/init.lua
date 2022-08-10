local awful         = require("awful")
local wibox         = require("wibox")
local shape         = require("commons.shape")

require("screen.tasks.buttons")

return {
  create = function(s)
    local name_section = {
      left   = 10,
      right  = 10,
      widget = wibox.container.margin,
      {
        layout        = wibox.container.scroll.horizontal,
        max_size      = 400,
        speed         = 300,
        step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
        {
            id     = 'text_role',
            widget = wibox.widget.textbox,
            align  = 'center',
            valign = 'center',
        }
      }
    }


    local widget_template = {
      name_section,
      shape  = shape.default_frr,
      widget = wibox.container.background,
    }

    return awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.focused,
        buttons = tasklist_buttons,
        widget_template = widget_template
    }
  end
}
