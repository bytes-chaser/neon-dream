local awful       = require("awful")
local wibox       = require("wibox")
local dpi         = require("beautiful").xresources.apply_dpi
local shape_utils = require("commons.shape")

local card  = require("widgets.card")

local packs = card.create_with_header_placeholder(createWidget(require("widgets.packages_list")))

return {
  create = function(s)
    local dev  = awful.wibar({

      position = "left",
      screen   = s,
      shape    = shape_utils.default_frr,
      visible  = false,
      width    = dpi(380),
      height   = dpi(1020),

      margins  = {
        left   = dpi(15)
      }

    })

    dev:setup{
      packs,
      layout = wibox.layout.flex.vertical
    }

    return dev


  end
}
