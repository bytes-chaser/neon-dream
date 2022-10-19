local naughty = require("naughty")
local gears = require("gears")

local now_playing = {
    nil,
    nil,
    nil,
}

awesome.connect_signal("player::icon_update",
        function(status, title, album, artist, art_link)

            if title ~= now_playing[1] or album ~= now_playing[2] or artist ~= now_playing[3] then
                now_playing[1] = title
                now_playing[2] = album
                now_playing[3] = artist

                naughty.notify({
                    text = title .. ' - ' .. artist,
                    app_name = 'Player',
                    title = 'Next playing...',
                    timeout = 10,
                    icon = gears.surface.load_uncached_silently(home_folder .. "/.cache/spotify/current_image")
                })
            end
        end
)