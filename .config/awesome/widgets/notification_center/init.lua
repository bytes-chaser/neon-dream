
local awful       = require("awful")
local wibox       = require("wibox")
local beautiful   = require("beautiful")
local dpi         = beautiful.xresources.apply_dpi
local gears       = require("gears")
local naughty     = require('naughty')
local shape_utils = require("commons.shape")
local icons       = require("commons.icons")

local notifications = wibox.widget({
  layout  = require("dependencies.overflow").vertical,
  spacing = dpi(8),
  scrollbar_widget = {
    widget = wibox.widget.separator,
    shape  = shape_utils.default_frr,
  },
  scrollbar_width = dpi(8),
  step            = 50,

})

local add_notif = function(title, text, notif_icon)
  local icon_widget = icons.wbic("", 25, beautiful.fg_focus)


  if notif_icon then
    icon_widget = {
      image         = notif_icon,
      widget        = wibox.widget.imagebox,
      forced_width  = dpi(beautiful.font_size * 2),
      forced_height = dpi(beautiful.font_size * 2),
    }
  end


  local close_icon = wibox.widget({
    id      = "icon",
    markup  =  "<span foreground='" .. beautiful.fg_focus .."'>" .. "" .. "</span>",
    align   = "center",
    opacity = 0,
    font    = beautiful.icons_font .. 20,
    widget  = wibox.widget.textbox,
  })


  local icon_section = {
    widget = wibox.container.margin,
    right  = dpi(15),
    icon_widget
  }


  local title_section = {
    markup  = "<span foreground='" .. beautiful.fg_focus .."'><b>" .. title .. "</b></span>",
    align   = "left",
    opacity = 1,
    font    = beautiful.font,
    widget  = wibox.widget.textbox,
  }


  local close_btn_section = {
    widget  = wibox.container.margin,
    margins = dpi(5),
    close_icon
  }


  local message_section = {
      text    = text,
      align   = "left",
      opacity = 1,
      font    = beautiful.font,
      widget  = wibox.widget.textbox,
  }


  local notification = wibox.widget({
    widget = wibox.container.margin,
    top    = dpi(10),
    right  = dpi(10),
    left   = dpi(10),
    {
      {
        {
          bg     = beautiful.palette_c7,
          widget = wibox.container.background,
          {
            widget = wibox.container.margin,
            top    = dpi(3),
            bottom = dpi(3),
            right  = dpi(5),
            left   = dpi(5),
            {
              icon_section,
              title_section,
              close_btn_section,
              layout = wibox.layout.align.horizontal
            }
          }
        },
        {
          widget = wibox.container.margin,
          top    = dpi(3),
          bottom = dpi(5),
          right  = dpi(10),
          left   = dpi(10),
          message_section
        },
        layout = wibox.layout.align.vertical
      },
      bg     = beautiful.palette_c6,
      shape  = shape_utils.default_frr,
      widget = wibox.container.background,
      height = dpi(30)
    }
  })


  close_icon:buttons(gears.table.join(awful.button({ }, 1, function()
    notifications:remove_widgets(notification, true)
  end)))


  notification:connect_signal('mouse::enter', function ()
      close_icon.opacity = 1
  end)


  notification:connect_signal('mouse::leave', function ()
      close_icon.opacity = 0
  end)


  return notification
end

local is_relevant_to_add = function (n)

  if n.app_name == "Player" then
    return false
  else
    return true
  end
end


local add = function(n, notif_icon)
	n:connect_signal(
		'destroyed',
		function(self, reason, keep_visble)
          if is_relevant_to_add(n) then
            local notif = add_notif(n.app_name, n.message, notif_icon)
            notifications:insert(1, notif)
          end

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
