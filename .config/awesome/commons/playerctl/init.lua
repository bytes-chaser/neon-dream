local awful = require("awful")
playerctl = {}
playerctl.command = {}
playerctl.command.kill_metadata_check = [[
  ps x | grep playerctl | grep -v grep | awk '{print $1}' | xargs kill
]]

playerctl.command.start_metadata_check = [[
 playerctl metadata --format '@artist{{artist}}artist@title{{title}}title@status{{status}}status@album{{album}}album@alink{{mpris:artUrl}}alink@position{{position}}position@length{{mpris:length}}length@' --follow
]]


awful.spawn.easy_async_with_shell(playerctl.command.kill_metadata_check, function ()

    awful.spawn.with_line_callback(playerctl.command.start_metadata_check, {
        stdout = function(line)
            local status = line:match('@status(.*)status@')
            local artist = line:match('@artist(.*)artist@')
            local title = line:match('@title(.*)title@')
            local album = line:match('@album(.*)album@')
            local art_link = line:match('@alink(.*)alink@')

            awesome.emit_signal("player::metadata", status, title, album, artist, art_link)
        end
    })
end)
