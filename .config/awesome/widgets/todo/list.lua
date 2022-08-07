local beautiful   = require("beautiful")
local dpi         = beautiful.xresources.apply_dpi
local wibox       = require("wibox")
local shape_utils = require("commons.shape")

return wibox.widget({
  layout = require("dependencies.overflow").vertical,
  spacing = dpi(8),
  scrollbar_widget = {
    widget = wibox.widget.separator,
    shape = shape_utils.partially_rounded_rect(beautiful.rounded, true, true, true, true),
  },
  scrollbar_width = dpi(8),
  step = 50,
})
