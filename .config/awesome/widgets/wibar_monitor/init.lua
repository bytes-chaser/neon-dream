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
      widget  = wibox.container.margin,
      margins = dpi(10),
      {
        id     = "wbm_body",
        layout = wibox.layout.fixed.horizontal,
        {
          id     = "wbm_labels",
          layout = wibox.layout.fixed.horizontal,

          label,
          percentage,
        },
        {
          id     = "wbm_graphs_margin",
          widget = wibox.container.margin,
          left   = dpi(10),
          {
            layout = wibox.layout.fixed.horizontal,
            id     = "wbm_graphs",

            graph
          }
        },
        nil
      }
    }
  end
}
