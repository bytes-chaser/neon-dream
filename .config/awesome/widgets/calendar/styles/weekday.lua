local beautiful   = require("beautiful")

return {
  fg_color = beautiful.palette_c4,
  markup   = function(t) return '<b>' .. t .. '</b>' end,
}
