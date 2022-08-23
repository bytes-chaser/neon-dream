local awful        = require("awful")
local wibox        = require("wibox")
local beautiful    = require("beautiful")
local dpi          = beautiful.xresources.apply_dpi
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

    awesome.connect_signal("sysstat::package_add", function()

        awful.spawn.easy_async_with_shell(commands.get_text_sorted(cfg.track_packages.cache_file, 1), function(pacs)
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
    end)


    return base_widget

  end
}
