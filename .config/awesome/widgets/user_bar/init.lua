local awful                = require("awful")
local wibox                = require("wibox")
local beautiful            = require("beautiful")
local dpi                  = beautiful.xresources.apply_dpi
local calendar             = require("widgets.calendar")
local shape_utils          = require("commons.shape")
local card                 = require("widgets.card")
local weather              = require("widgets.weather")
local todo                 = require("widgets.todo")
user_bar = {}

user_bar.create = function(s)


  s.user = awful.wibar({
    position = "left",
    screen   = s,
    shape    = shape_utils.partially_rounded_rect(beautiful.rounded, true, true, true, true),
    visible  = false,
    width    = dpi(600),
    height   = dpi(1000),
    margins  = {
      left = dpi(15)
    }
  })

  s.user:setup{
    card.create({
      require("widgets.profile"),
      nil,
      weather.create(),
      layout = wibox.layout.align.horizontal
    }),
    {

      layout = wibox.layout.flex.vertical,
      {
        card.create(require("widgets.player")),

        layout = wibox.layout.flex.horizontal
      },
      {
        card.create(require("widgets.sliders_set")),
        card.create(calendar.create()),
        layout = wibox.layout.flex.horizontal
      },
      {
        card.create(todo.create()),
        layout = wibox.layout.flex.horizontal
      },
    },

    layout = wibox.layout.align.vertical
  }

end

return user_bar
