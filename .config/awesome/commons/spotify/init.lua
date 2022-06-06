

local spotify = {}
spotify.commands = {}
spotify.commands.base = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player."
spotify.commands.toggle = spotify.commands.base .. "PlayPause"
spotify.commands.prev = spotify.commands.base .. "Previous"
spotify.commands.next = spotify.commands.base .. "Next"
return spotify
