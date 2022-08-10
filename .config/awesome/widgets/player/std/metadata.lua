local awful       = require("awful")
local wibox       = require("wibox")
local beautiful   = require("beautiful")

return {
  label = function(glyph)
    return wibox.widget{
        text    = glyph,
        align   = "center",
        opacity = 1,
        font    = beautiful.icons_font .. " Bold 16",
        widget  = wibox.widget.textbox,
    }
  end,

  value = function(glyph)
    return wibox.widget{
        text    = glyph,
        opacity = 1,
        font    = beautiful.font .. " ExtraBold 16",
        widget  = wibox.widget.textbox,
    }
  end
}
