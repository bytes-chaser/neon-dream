local beautiful   = require("beautiful")

return {
  fg_color = beautiful.pallete_c4,
  markup   = function(t) return '<b>' .. t .. '</b>' end,
}
