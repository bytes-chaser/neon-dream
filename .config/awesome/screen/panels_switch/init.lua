local awful         = require("awful")
local gears         = require("gears")
local beautiful     = require("beautiful")
local wibox         = require("wibox")
local dpi           = beautiful.xresources.apply_dpi
local icons         = require("commons.icons")


local close_all_sub_panels = function(s)
  s.stats.visible    = false
  s.dev.visible      = false
  s.user.visible     = false
end


local create_munu_panel_button = function(glyph, text, btn_fn)
  local btn = wibox.widget{
      {
        {
          icons.wbi(glyph, 12),
          margins = dpi(5),
          widget = wibox.container.margin
        },
        bg = beautiful.palette_c7,
        widget = wibox.container.background
      },
      margins = dpi(5),
      widget = wibox.container.margin

  }

  local myclock_t = awful.tooltip {
      objects        = { btn },
      timer_function = function()
          return text
      end,
  }

  btn_fn(btn)
  return btn
end


return {
  create = function(s)
    return {
      layout = wibox.layout.fixed.horizontal,


      create_munu_panel_button("", "User", function(btn)
        btn:buttons(gears.table.join(awful.button({ }, 1, function()
          if sub_panel_mode == 'user' and show_sub_panel then
            s.user.visible = false
            show_sub_panel = false
          else
            if not sub_panel_mode ~= 'user' then
              close_all_sub_panels(s)
            end
            show_sub_panel = true
            sub_panel_mode = 'user'
            s.user.visible = true

          end
        end)))
      end),

      create_munu_panel_button("", "Devtools", function(btn)
        btn:buttons(gears.table.join(awful.button({ }, 1, function()
          if sub_panel_mode == 'dev' and show_sub_panel then
            s.dev.visible  = false
            show_sub_panel = false
          else
            if not sub_panel_mode ~= 'dev' then
              close_all_sub_panels(s)
            end
            show_sub_panel = true
            sub_panel_mode = 'dev'
            s.dev.visible  = true

          end
        end)))
      end),

      create_munu_panel_button("", "Stats", function(btn)
        btn:buttons(gears.table.join(awful.button({ }, 1, function()
          if sub_panel_mode == 'stat' and show_sub_panel then
            s.stats.visible = false
            show_sub_panel  = false
          else
            if not sub_panel_mode ~= 'stat' then
              close_all_sub_panels(s)
            end
            show_sub_panel  = true
            sub_panel_mode  = 'stat'
            s.stats.visible = true

          end
        end)))
      end),
    }
  end
}
