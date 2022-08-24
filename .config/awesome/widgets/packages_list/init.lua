local awful        = require("awful")
local wibox        = require("wibox")
local beautiful    = require("beautiful")
local dpi          = beautiful.xresources.apply_dpi
local droplist     = require("widgets.droplist")
local shape_utils  = require("commons.shape")
local commands     = require("commons.commands")
local package_item = require("widgets.packages_list.item")

return {
  create = function()

    local base_widget = wibox.widget({
  		layout  = require("dependencies.overflow").vertical,
  		spacing = dpi(5),
  		scrollbar_widget = {
  			widget = wibox.widget.separator,
  			shape  = shape_utils.default_frr,
  		},
  		scrollbar_width = dpi(8),
  		step            = 50,
  	})

      local col = 1

      function update()

          awful.spawn.easy_async_with_shell(commands.get_text_sorted(cfg.track_packages.cache_file, col), function(pacs)
              base_widget:reset()

              for line in pacs:gmatch('([^\n]+)') do
                  local arr = nd_utils.split(line, ' ')

                  local name      = arr[1]
                  local c_color   = arr[2]
                  local c_version = arr[3]
                  local a_color   = arr[4]
                  local a_font    = arr[5]
                  local a_version = arr[6]

                  base_widget:add(package_item.create(name, c_version, c_color, a_version, a_font, a_color))

              end
          end)
      end

      awesome.connect_signal("sysstat::package_add", update)

      local sort_menu = wibox.widget({
          text   = 'Sort by:',
          align = "left",
          opacity = 1,
          font = beautiful.font_famaly .. '10',
          widget = wibox.widget.textbox,
      })

      droplist.create(sort_menu,
              shape_utils.partially_rounded_rect(false, true, true, false, beautiful.rounded),
              'right', 'middle', {
                  {
                      name = "Name",
                      default = true,
                      callback = function(parent)
                          parent.text = 'Sort by: Name'
                          col = 1
                          update()
                      end,
                  },
                  {
                      name = "Current version",
                      callback = function(parent)
                          parent.text = 'Sort by: Current version'
                          col = 3
                          update()
                      end
                  },
                  {
                      name = "Available version",
                      callback = function(parent)
                          parent.text = 'Sort by: Available version'
                          col = 6
                          update()
                      end
                  }
              })



      local header_widget = wibox.widget({
          widget = wibox.container.margin,
          margins = dpi(5),
          {
              widget = wibox.container.background,
              forced_height = dpi(60),
              {
                  layout = wibox.layout.align.horizontal,
                  nil,
                  nil,
                  sort_menu
              }
          }

      })

      return wibox.widget({
          widget = wibox.layout.fixed.vertical,
          header_widget,
          base_widget

      })

  end
}
