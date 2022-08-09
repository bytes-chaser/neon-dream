local wibox       = require("wibox")
local beautiful   = require("beautiful")
local dpi         = beautiful.xresources.apply_dpi

return {
  create = function()
    return wibox.widget{
        id            = "text_status",
        text          = "0%",
        align         = "center",
        forced_width  = dpi(80),
        opacity       = 1,
        font          = beautiful.font_famaly .. " Bold 16",
        widget        = wibox.widget.textbox,
    }
  end
}
