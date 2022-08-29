local beautiful            = require("beautiful")
local wibox                = require("wibox")


local text = wibox.widget({
    widget = wibox.widget.textbox,
    text = "",
    font = beautiful.font_famaly .. '20',
    align  = 'center',
    valign = 'center',
    font = beautiful.font_famaly .. '20',
})

local perc = wibox.widget({
    widget = wibox.widget.textbox,
    markup = "<span foreground='" .. beautiful.pallete_c1 .."'>0%</span>",
    align  = 'center',
    valign = 'center',
    font = beautiful.font_famaly .. '16',
})


awesome.connect_signal("sysstat::cpu",
        function(val, postfix)
            perc.markup = "<span foreground='" .. beautiful.pallete_c1 .."'>" .. val .. postfix .."</span>"
        end)

return {
    widget = wibox.container.place,
    valign = 'center',
    halign = 'center',
    {
        layout = wibox.layout.fixed.vertical,
        text,
        perc,
    }
}