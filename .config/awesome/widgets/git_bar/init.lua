local awful       = require("awful")
local wibox       = require("wibox")
local dpi         = require("beautiful").xresources.apply_dpi
local shape_utils = require("commons.shape")

local card  = require("widgets.card")
local repos = card.create(require("widgets.repos").create())

return {
  create = function(s)
    local repo_bar  = awful.wibar({

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

    repo_bar:setup{
      repos,
      layout = wibox.layout.flex.vertical
    }

    return repo_bar


  end
}
