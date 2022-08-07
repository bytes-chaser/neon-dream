local beautiful   = require("beautiful")

return {
  fg_color = beautiful.pallete_c1,
  markup   = function(t) return '<b>' .. t .. '</b>' end,
}
