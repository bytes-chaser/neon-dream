local awful         = require("awful")
local gears         = require("gears")
local beautiful     = require("beautiful")
local wibox         = require("wibox")
local dpi           = beautiful.xresources.apply_dpi
local icons         = require("commons.icons")
local shapes         = require("commons.shape")

local active_panel_switch_icon
local active_panel_switch_icon_section

local close_all_sub_panels = function(s)
  s.stats.visible    = false
  s.dev.visible      = false
  s.docker.visible     = false
  s.user.visible     = false
  if active_panel_switch_icon and active_panel_switch_icon_section then
	active_panel_switch_icon_section.markup = "<span foreground='" .. beautiful.fg_normal .. "'>" .. active_panel_switch_icon .. "</span>"
  end
end


local create_munu_panel_button = function(glyph, text, btn_fn)
  
   local icon = icons.wbic(glyph, 12, beautiful.fg_normal)

   local btn = wibox.widget{
      {
	icon,
	forced_width  = dpi(25),
	forced_heigth = dpi(15),
        bg 	      = beautiful.palette_c7,
        shape         = shapes.circle(dpi(25)),
        widget 	  = wibox.container.background
      },
      margins = dpi(5),
      widget  = wibox.container.margin

  }

  awful.tooltip {
      objects        = { btn },
      timer_function = function()
          return text
      end,
  }

  btn_fn(btn, icon)
  return btn
end


return {
  create = function(s)
    return {
      layout = wibox.layout.fixed.horizontal,


      create_munu_panel_button("", "User", function(btn, icon)
        btn:buttons(gears.table.join(awful.button({ }, 1, function()
          if sub_panel_mode == 'user' and show_sub_panel then
            s.user.visible = false
            show_sub_panel = false
            icon.markup    = "<span foreground='" .. beautiful.fg_normal .. "'>" .. "" .. "</span>"
          else
            if not sub_panel_mode ~= 'user' then
              icon.markup  = "<span foreground='" .. beautiful.fg_normal .. "'>" .. "" .. "</span>"
              close_all_sub_panels(s)
            end
            show_sub_panel = true
            sub_panel_mode = 'user'
            s.user.visible = true
            icon.markup    = "<span foreground='" .. beautiful.fg_focus .. "'>" .. "" .. "</span>"

            active_panel_switch_icon = ""
            active_panel_switch_icon_section = icon

          end
        end)))
      end),

      create_munu_panel_button("", "Devtools", function(btn, icon)
        btn:buttons(gears.table.join(awful.button({ }, 1, function()
          if sub_panel_mode == 'dev' and show_sub_panel then
            s.dev.visible  = false
            show_sub_panel = false
            icon.markup    = "<span foreground='" .. beautiful.fg_normal .. "'>" .. "" .. "</span>"
          else
            if not sub_panel_mode ~= 'dev' then
              icon.markup  = "<span foreground='" .. beautiful.fg_normal .. "'>" .. "" .. "</span>"
              close_all_sub_panels(s)
            end
            show_sub_panel = true
            sub_panel_mode = 'dev'
            s.dev.visible  = true
            icon.markup    = "<span foreground='" .. beautiful.fg_focus .. "'>" .. "" .. "</span>"
	    
            active_panel_switch_icon = ""
            active_panel_switch_icon_section = icon
            
          end
        end)))
      end),

      create_munu_panel_button('', "Docker", function(btn, icon)
        btn:buttons(gears.table.join(awful.button({ }, 1, function()
          if sub_panel_mode == 'docker' and show_sub_panel then
            s.docker.visible  = false
            show_sub_panel = false
            icon.markup    = "<span foreground='" .. beautiful.fg_normal .. "'>" .. '' .. "</span>"
          else
            if not sub_panel_mode ~= 'docker' then
              icon.markup  = "<span foreground='" .. beautiful.fg_normal .. "'>" .. '' .. "</span>"
              close_all_sub_panels(s)
            end
            show_sub_panel = true
            sub_panel_mode = 'docker'
            s.docker.visible  = true
            icon.markup    = "<span foreground='" .. beautiful.fg_focus .. "'>" .. '' .. "</span>"

            active_panel_switch_icon = ''
            active_panel_switch_icon_section = icon

          end
        end)))
      end),

      create_munu_panel_button("", "Stats", function(btn, icon)
        btn:buttons(gears.table.join(awful.button({ }, 1, function()
          if sub_panel_mode == 'stat' and show_sub_panel then
            s.stats.visible = false
            show_sub_panel  = false
            icon.markup     = "<span foreground='" .. beautiful.fg_normal .. "'>" .. "" .. "</span>"
          else
            if not sub_panel_mode ~= 'stat' then
              icon.markup   = "<span foreground='" .. beautiful.fg_normal .. "'>" .. "" .. "</span>"
              close_all_sub_panels(s)
            end
            show_sub_panel  = true
            sub_panel_mode  = 'stat'
            s.stats.visible = true
            icon.markup     = "<span foreground='" .. beautiful.fg_focus .. "'>" .. "" .. "</span>"

            active_panel_switch_icon = ""
            active_panel_switch_icon_section = icon
          end
        end)))
      end),
    }
  end
}
