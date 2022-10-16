local beautiful            = require("beautiful")
local wibox                = require("wibox")


local text = wibox.widget({
    widget = wibox.widget.textbox,
    text = "/efi",
    font = beautiful.font_famaly .. '16',
    align  = 'center',
    valign = 'center',
})

local perc = wibox.widget({
    widget = wibox.widget.textbox,
    markup = "<span foreground='" .. beautiful.palette_c1 .."'>0%</span>",
    align  = 'center',
    valign = 'center',
    font = beautiful.font_famaly .. '16',
})

local abs = wibox.widget({
    widget = wibox.widget.textbox,
    text = "0/0",
    align  = 'center',
    valign = 'center',
    font = beautiful.font_famaly .. '8',
})


awesome.connect_signal("sysstat:disk_boot",
        function(val, postfix, used, total)
            local used_text  = math.floor(used / 1000)   .. '.'   .. (math.floor(math.floor(used % 1000) / 10))
            local total_text = math.floor(total / 1000)  .. '.'   .. (math.floor(math.floor(total % 1000) / 10))
            perc.markup = "<span foreground='" .. beautiful.palette_c1 .."'>" .. val .. postfix .."</span>"
            abs.text = used_text .. '/' .. total_text .. ' GB'
        end)

return {
    widget = wibox.container.place,
    valign = 'center',
    halign = 'center',
    {
        layout = wibox.layout.fixed.vertical,
        text,
        perc,
        abs
    }
}