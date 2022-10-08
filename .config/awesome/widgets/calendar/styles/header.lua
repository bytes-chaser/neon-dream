local beautiful   = require("beautiful")

return {
  fg_color = beautiful.palette_c1,
  markup   = function(t) return '<b>' .. t .. '</b>' end,
}
