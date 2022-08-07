local dpi         = require("beautiful").xresources.apply_dpi
local wibox       = require("wibox")
local shape_utils = require("commons.shape")

return wibox.widget({
  layout = require("dependencies.overflow").vertical,
  spacing = dpi(8),
  scrollbar_widget = {
    widget = wibox.widget.separator,
    shape = shape_utils.default_frr,
  },
  scrollbar_width = dpi(8),
  step = 50,
})
