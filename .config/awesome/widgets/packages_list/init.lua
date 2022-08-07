local awful        = require("awful")
local wibox        = require("wibox")
local beautiful    = require("beautiful")
local dpi          = beautiful.xresources.apply_dpi
local shape_utils  = require("commons.shape")

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

    awesome.connect_signal("sysstat::package_sync", function()

      for k, package in pairs(cfg.track_packages) do
        local row = base_widget.children[k]

        local check_updates = "pacman -Qu " .. package .." | awk '{printf $4}'"
        local check_current = "pacman -Q " .. package .." | awk '{printf $2}'"

        awful.spawn.easy_async_with_shell(check_updates, function(out)
          local is_outdated = (#out == 0)

          local avail_text = "<span foreground='#48b892'>" .. (is_outdated and '' or out) .. "</span>"
          local avail_font = beautiful.font_famaly .. (is_outdated and '16' or '12')

          awful.spawn.easy_async_with_shell(check_current, function(version)
            local color = is_outdated and '#48b892' or '#b84860'
            local item  = package_item.create(package, version, avail_text, color, avail_font)
            base_widget:add(item)
          end)
        end)
      end
    end)

    return base_widget

  end
}
