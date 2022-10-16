local disk_callback = function(sig, widget, stdout)

    local used = stdout:match('(.*) ')
    local available  = stdout:match(' (.*)')
    local total = used + available
    local val = math.ceil(100 * (tonumber(used) / tonumber(total)))
    awesome.emit_signal(sig, val, '%', used, total)
end

return {
    {
        command = [[
                zsh -c "free -m | grep Mem: | awk '{printf \"#%d__%d#\", $2, $3}'"
            ]],
        interval = 2,
        callback = function(widget, stdout)
            local total = stdout:match('#(.*)__')
            local used  = stdout:match('__(.*)#')
            local val = math.floor(100 * (tonumber(used) / tonumber(total)))
            awesome.emit_signal("sysstat::ram", val, '%', total, used)
        end
    },
    {
        command = [[
            zsh -c "top -bn2 | grep '%Cpu' | tail -1 | grep -P '(....|...) id,'|awk '{print 100-$8}'"
        ]],
        interval = 2,
        callback = function(widget, stdout)
            awesome.emit_signal("sysstat::cpu", tonumber(stdout), '%')
        end
    },
    {
        command = [[
          zsh -c "{cat /sys/class/power_supply/BAT0/status | sed 's/ //g';cat /sys/class/power_supply/BAT0/capacity} | paste -d ' ' -s" | awk '{printf "#" $1 "__" $2 "#"}'
        ]],
        interval = 2,
        callback = function(widget, stdout)
            local capacity  = stdout:match(' (.*)')
            local status    = stdout:match('(.*) ')
            awesome.emit_signal("sysstat::pow", tonumber(capacity), '%', status)
        end
    },
    {
        command = [[
            zsh -c "sensors | grep Package | awk '{printf \"%d\", $4}'"
          ]],
        interval = 30,
        callback = function(widget, stdout)
            awesome.emit_signal("sysstat::temp", tonumber(stdout), '°C')
        end
    },
    {
        command = ([[
            zsh -c "df -B 1MB / | tail -1 | awk '{printf \"%d %d\", $3, $4}'"
          ]]),
        interval = 30,
        callback = function(widget, stdout)
            disk_callback("sysstat:disk_root", widget, stdout)
        end
    },
    {
        command = ([[
            zsh -c "df -B 1MB /efi | tail -1 | awk '{printf \"%d %d\", $3, $4}'"
          ]]),
        interval = 30,
        callback = function(widget, stdout)
            disk_callback("sysstat:disk_boot", widget, stdout)
        end
    },
    {
        command = ([[
            zsh -c "df -B 1MB /home | tail -1 | awk '{printf \"%d %d\", $3, $4}'"
          ]]),
        interval = 30,
        callback = function(widget, stdout)
            disk_callback("sysstat:disk_home", widget, stdout)
        end
    }

}