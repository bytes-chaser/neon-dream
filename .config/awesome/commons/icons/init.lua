
local wibox             = require("wibox")
local beautiful         = require("beautiful")
local dpi               = beautiful.xresources.apply_dpi

local icons = {}

-- wibox text icon
icons.wbi = function(glyph, size, init_opacity)
    local icon = wibox.widget{
        text   = glyph,
        align = "center",
        opacity = init_opacity,
        font = beautiful.icons_font .. size,
        widget = wibox.widget.textbox,
    } 

    return icon
end

-- wibox text icon with opacity change on focus
icons.wbifo = function(glyph, size, init_opacity, focus_opacity)
    local icon = icons.wbi(glyph, size, init_opacity)

    icon:connect_signal('mouse::enter', function ()
        icon.opacity = focus_opacity
    end)

    icon:connect_signal('mouse::leave', function ()
        icon.opacity = init_opacity
      end)

    return icon

end


return icons