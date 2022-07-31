local awful       = require("awful")
local wibox       = require("wibox")
local beautiful   = require("beautiful")
local dpi         = beautiful.xresources.apply_dpi
local shape_utils = require("commons.shape")

local packages_list = {}

packages_list.create = function()


  local base = {
		layout = require("dependencies.overflow").vertical,
		spacing = dpi(5),
		scrollbar_widget = {
			widget = wibox.widget.separator,
			shape = shape_utils.partially_rounded_rect(beautiful.rounded, true, true, true, true),
		},
		scrollbar_width = dpi(8),
		step = 50,
	}

  local base_widget = wibox.widget(base)

  awesome.connect_signal("sysstat::package_sync", function()

    for k, package in pairs(cfg.track_packages) do
      local row = base_widget.children[k]

      awful.spawn.easy_async_with_shell("pacman -Qu " .. package .." | awk '{printf $4}'", function(out)

        local available_text = 'pending...'
        local available_text_font = beautiful.font_famaly .. '16'
        local is_outdated = false
        if #out == 0 then
          available_text = "<span foreground='#48b892'></span>"
        else
          available_text = "<span foreground='#48b892'>" .. out .. "</span>"
          available_text_font = beautiful.font_famaly .. '12'
          is_outdated = true
        end

        awful.spawn.easy_async_with_shell("pacman -Q " .. package .." | awk '{printf $2}'", function(out)
          local color = '#48b892'
          if is_outdated then
            color = '#b84860'
          end

          base_widget:add({
            id = package,
            {
              {
                {
                  widget = wibox.widget.textbox,
                  markup   = "<span foreground='" .. beautiful.fg_focus .."'>" .. package .."</span>",
                  font = beautiful.font_famaly .. '12',
                },
                {
                  {
                     layout = wibox.container.scroll.horizontal,
                     max_size = 100,
                     step_function = wibox.container.scroll.step_functions.nonlinear_back_and_forth,
                     speed = 100,
                     {
                       widget = wibox.widget.textbox,
                       markup = "<span foreground='" .. color .."'>" .. out .. "</span>",
                       font = beautiful.font_famaly .. '12',
                     },
                  },
                  {
                    widget = wibox.container.background
                  },
                  {
                    layout = wibox.container.scroll.horizontal,
                    max_size = 100,
                    step_function = wibox.container.scroll.step_functions.nonlinear_back_and_forth,
                    speed = 100,
                    {
                      align  = "right",
                      widget = wibox.widget.textbox,
                      markup = available_text,
                      font = available_text_font,
                    }
                  },
                  layout = wibox.layout.flex.horizontal,
                },
                layout = wibox.layout.flex.vertical,
              },
              widget  = wibox.container.margin,
              margins = dpi(10)
            },
            forced_height = dpi(65),
            widget = wibox.container.background,
            bg = beautiful.palette_c7,
          })
        end)
      end)

    end


  end)

return base_widget

end

return packages_list
