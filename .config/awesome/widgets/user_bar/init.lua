local awful                = require("awful")
local wibox                = require("wibox")
local beautiful            = require("beautiful")
local dpi                  = require("beautiful").xresources.apply_dpi
local calendar             = require("widgets.calendar")
local shape_utils          = require("commons.shape")
local card                 = require("widgets.card")

local weather    = require("widgets.weather").create()
local calendar   = require("widgets.calendar").create()
local todo       = require("widgets.todo").create()
local player     = require("widgets.player.std")
local sliders    = require("widgets.sliders_set")
local profile    = require("widgets.profile")

return {
  create = function(s)

    local user = awful.wibar({
      position = "left",
      screen   = s,
      shape    = shape_utils.default_frr,
      visible  = false,
      width    = dpi(600),
      height   = dpi(1020),
      margins  = {
        left = dpi(15)
      }
    })

    local header = card.create({
      profile,
      nil,
      weather,
      layout = wibox.layout.align.horizontal
    })

    local play = {
      card.create(player),
      layout = wibox.layout.flex.horizontal
    }

    local sliders_and_calendar = {
      card.create(sliders),
      card.create(calendar),
      layout = wibox.layout.flex.horizontal
    }

    local tasks = {
      card.create(todo),
      layout = wibox.layout.flex.horizontal
    }

    user:setup{
      layout = wibox.layout.align.vertical,
      header,
      {
        layout = wibox.layout.flex.vertical,
        play,
        sliders_and_calendar,
        tasks,
      }
    }

    return user
  end
}
