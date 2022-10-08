local awful                = require("awful")
local wibox                = require("wibox")
local dpi                  = require("beautiful").xresources.apply_dpi
local shape_utils          = require("commons.shape")
local processes            = require("widgets.processes")
local arcchart_stat        = require("widgets.arcchart_stat")

return {
    create = function(s)

        local stat = awful.wibar({
            position = "left",
            screen   = s,
            shape    = shape_utils.default_frr,
            visible  = false,
            width    = dpi(380),
            height   = dpi(1020),
            margins  = {
                left = dpi(15)
            }
        })

        local temp = arcchart_stat.create(require("widgets.stat_bar.v2.temp_text"))
        local ram = arcchart_stat.create(require("widgets.stat_bar.v2.ram_text"))
        local cpu = arcchart_stat.create(require("widgets.stat_bar.v2.cpu_text"))

        local d_root = arcchart_stat.create(require("widgets.stat_bar.v2.d_root"))
        local d_home = arcchart_stat.create(require("widgets.stat_bar.v2.d_home"))
        local d_boot = arcchart_stat.create(require("widgets.stat_bar.v2.d_efi"))

        awesome.connect_signal("sysstat::temp",
                function(val)
                    temp.mirr.bar.value = val
                end)

        awesome.connect_signal("sysstat::ram",
                function(val)
                    ram.mirr.bar.value = val
                end)

        awesome.connect_signal("sysstat::cpu",
            function(val)
                cpu.mirr.bar.value = val
            end)

        awesome.connect_signal("sysstat:disk_root",
            function(val)
                d_root.mirr.bar.value = val
            end)

        awesome.connect_signal("sysstat:disk_boot",
                function(val)
                    d_boot.mirr.bar.value = val
                end)

        awesome.connect_signal("sysstat:disk_home",
                function(val)
                    d_home.mirr.bar.value = val
                end)




        stat:setup{
            {
                processes.create(),
                widget = wibox.container.margin,
                top = dpi(5),
                right = dpi(10),
                left = dpi(10),
            },
            {
                temp,
                {
                    layout = wibox.layout.flex.horizontal,
                    ram,
                    cpu,

                },
                layout = wibox.layout.flex.vertical,
            }
            ,
            {
                layout = wibox.layout.flex.vertical,
                {
                    layout = wibox.layout.flex.horizontal,
                    d_boot,
                    d_root
                    ,

                },
                {
                    widget = wibox.container.place,
                    valign = 'top',
                    {
                        layout = wibox.layout.align.horizontal,
                        {
                            widget = wibox.container.background,
                            forced_width = dpi(70)
                        },
                        d_home,
                        {
                            widget = wibox.container.background,
                            forced_width = dpi(70)
                        },

                    }
                },
            },
            layout = wibox.layout.flex.vertical
        }

        return stat

    end
}
