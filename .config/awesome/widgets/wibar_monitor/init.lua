local wibox       = require("wibox")
local beautiful   = require("beautiful")
local dpi         = beautiful.xresources.apply_dpi


return {
  create = function(label_text)
    local label = {
      text   = label_text,
      align  = 'center',
      valign = 'center',
      widget = wibox.widget.textbox
    }

    local percentage = {
      id     = "wbm_valtext",
      text   = '0%',
      align  = 'center',
      valign = 'center',
      widget = wibox.widget.textbox
    }

    local graph = {
      widget           = wibox.widget.graph,
      min_value        = 0,
      max_value        = 100,
      step_spacing     = 5,
      step_width       = 10,
      scale            = true,
      border_color     = beautiful.pallete_c1,
      color            = beautiful.fg_normal,
      background_color = beautiful.palette_c6,
      id               = "wbm_graph"
    }

    return wibox.widget{
      {
        layout = wibox.layout.fixed.horizontal,
        {
          label,
          percentage,
          layout = wibox.layout.fixed.horizontal,
          id = "wbm_labels"
        },
        {
          widget = wibox.container.margin,
          left = dpi(10),
          {
            graph,
            layout = wibox.layout.fixed.horizontal,
            id     = "wbm_graphs"
          },
          id = "wbm_graphs_margin"
        },
        nil,
        id = "wbm_body"
      },
      widget  = wibox.container.margin,
      margins = dpi(10),
    }


  end
}
