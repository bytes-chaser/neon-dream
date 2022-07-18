local awful       = require("awful")
local wibox       = require("wibox")
local beautiful   = require("beautiful")
local dpi         = beautiful.xresources.apply_dpi
local gears       = require("gears")
local naughty = require('naughty')
local shape_utils = require("commons.shape")
local icons = require("commons.icons")

local notifications = wibox.widget({
  layout = wibox.layout.fixed.vertical,
})


local add_notif = function(title, text, notif_icon)
  local icon_widget = nil

  if notif_icon then
    icon_widget = {
      image = notif_icon,
      widget = wibox.widget.imagebox,
      forced_width = dpi(beautiful.font_size * 2),
      forced_height = dpi(beautiful.font_size * 2),
    }
    else
      icon_widget = icons.wbi("", 25)
  end

  local notification =  wibox.widget({
    widget = wibox.container.margin,
    top = dpi(10),
    right = dpi(10),
    left = dpi(10),
    {
      id = "box",
      {
        id = "box_list",
        {
          id = "header",
          bg = beautiful.palette_c7,
          widget = wibox.container.background,
          {
            id = "margin",
            widget = wibox.container.margin,
            top = dpi(3),
            bottom = dpi(3),
            right = dpi(5),
            left = dpi(5),
            {
              id = "list",
              {
                widget = wibox.container.margin,
                right = dpi(15),
                icon_widget
              },
              {
                    text   = title,
                    align = "left",
                    opacity = 1,
                    font = beautiful.font,
                    widget = wibox.widget.textbox,
              },
              {
                id = "icon_margin",
                widget = wibox.container.margin,
                margins = dpi(5),
                {
                    id = "icon",
                    text   = "",
                    align = "center",
                    opacity = 1,
                    font = beautiful.icons_font .. 20,
                    widget = wibox.widget.textbox,
                }
              },
              layout = wibox.layout.align.horizontal
            }
          }
        },
        {
          widget = wibox.container.margin,
          top = dpi(3),
          bottom = dpi(3),
          right = dpi(5),
          left = dpi(5),
          {
              text   = text,
              align = "left",
              opacity = 1,
              font = beautiful.font,
              widget = wibox.widget.textbox,
          }
        },
        layout = wibox.layout.fixed.vertical
      },
      bg = beautiful.palette_c6,
      widget = wibox.container.background,
      height = dpi(30)
    }
  })

  local icon = notification.box.box_list.header.margin.list.icon_margin.icon;
  icon:buttons(gears.table.join(awful.button({ }, 1, function()
    notifications:remove_widgets(notification, true)
  end)))
return notification
end


notifications:insert(1, add_notif("man", "man"))


local add = function(n, notif_icon)
	n:connect_signal(
		'destroyed',
		function(self, reason, keep_visble)
      local notif = add_notif(n.title, n.message, notif_icon)
      notifications:insert(1, notif)
		end
	)
end

naughty.connect_signal(
	'added',
	function(n)
    local notif_icon = n.icon or n.app_icon
		add(n, notif_icon)
	end
)



return notifications
