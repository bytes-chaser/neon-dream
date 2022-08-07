local awful       = require("awful")
local wibox       = require("wibox")
local beautiful   = require("beautiful")
local dpi         = beautiful.xresources.apply_dpi
local shape_utils = require("commons.shape")

local card  = require("widgets.card")
local packs = card.create_with_header("Packages", require("widgets.packages_list").create())
local repos = card.create_with_header("Repositories", require("widgets.repos").create())

return {
  create = function(s)
    s.dev = awful.wibar({
      position = "left",
      screen   = s,
      shape    = shape_utils.partially_rounded_rect(beautiful.rounded, true, true, true, true),
      visible  = false,
      width    = dpi(500),
      height   = dpi(1000),
      margins  = {
        left = dpi(15)
      }
    })

    s.dev:setup{
      packs,
      repos,
      layout = wibox.layout.flex.vertical
    }


  end
}
