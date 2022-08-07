local awful       = require("awful")
local wibox       = require("wibox")
local beautiful   = require("beautiful")
local dpi         = beautiful.xresources.apply_dpi
local gears       = require("gears")
local commands    = require("commons.commands")
local text_format = require("commons.text_format")

player_works = false

local on_player_pause_cmd = "spotify"

local controls = require("widgets.player.controls")
local metadata = require("widgets.player.metadata")


local make_metadata_margin = function(content)
  return {
    content,
    widget = wibox.container.margin,
    left   = dpi(5),
    right  = dpi(5)
  }
end


local make_hor_layout = function(l, v)
  return {
    make_metadata_margin(l),
    {
      layout = wibox.container.scroll.horizontal,
      max_size = 100,
      step_function = wibox.container.scroll.step_functions.nonlinear_back_and_forth,
      speed = 100,
      v
    },
    layout = wibox.layout.align.horizontal
  }
end


local make_ctr_margin = function(content)
  return {
    content,
    widget = wibox.container.margin,
    margins = dpi(3)
  }
end

local title_label = metadata.label("")
local album_label  = metadata.label("")
local artist_label = metadata.label("")

local title_val  = metadata.value("Open")
local album_val  = metadata.value("Spotify")
local artist_val = metadata.value("To Start")


local text_metadata = {
  make_hor_layout(title_label,  title_val),
  make_hor_layout(album_label,  album_val),
  make_hor_layout(artist_label, artist_val),
  layout = wibox.layout.fixed.vertical
}


local prv_btn = controls.create("", commands.player_prev)
local tgl_btn = controls.create("", commands.player_toggle)
local nxt_btn = controls.create("", commands.player_next)


local control_panel = {
  make_ctr_margin(prv_btn),
  make_ctr_margin(tgl_btn),
  make_ctr_margin(nxt_btn),
  layout = wibox.layout.flex.horizontal
}

local stops = {
  { 0.0, beautiful.palette_c6 .. "11" },
  { 0.7, beautiful.palette_c6 .. "CC" },
  { 0.8, beautiful.palette_c6 .. "DD" },
  { 0.9, beautiful.palette_c6 .. "EE" },
  { 1.0, beautiful.palette_c6 }
}

local filter_color_north = {
	type  = "linear",
	from  = { 0, 0 },
	to    = { 0, 280 },
  stops = stops,
}

local filter_color_east = {
	type  = "linear",
	from  = { 0, 0 },
	to    = { 0, 250 },
  stops = stops,
}

local imagebox = wibox.widget({
    id = "art",
    resize = true,
    widget = wibox.widget.imagebox,
})

local player = wibox.widget({
    imagebox,
    {
      {
        bg     = filter_color_east,
        widget = wibox.container.background
      },
      direction = "east",
	    widget    = wibox.container.rotate,
    },
    {
      {
        layout = wibox.layout.flex.vertical,
        {
            {
              widget = wibox.container.background,
            },
            text_metadata,
            layout = wibox.layout.flex.horizontal,
        },
        control_panel
      },
      bg     = filter_color_north,
      widget = wibox.container.background,
    },
    layout = wibox.layout.stack,
  })


awesome.connect_signal("player::metadata",
  function(status, title, album, artist, art_link)

    if status == nil then
      player_works = false
    elseif status:match("Paused") then
      tgl_btn.text = ""
      player_works = true
    elseif status:match("Playing") then
      tgl_btn.text = ""
      player_works = true
    end

    if player_works then
      title_val.text  = text_format.shorting(title,  30)
      album_val.text  = text_format.shorting(album,  30)
      artist_val.text = text_format.shorting(artist, 30)

      awful.spawn.easy_async_with_shell("curl -o " .. home_folder .. "/.cache/spotify/current_image " .. art_link,
        function()
          imagebox.image = gears.surface.load_uncached_silently(home_folder .. "/.cache/spotify/current_image")
        end)
      else
        title_val.text  = "Click"
        album_val.text  = "To start"
        artist_val.text = on_player_pause_cmd
    end
end)

return player
