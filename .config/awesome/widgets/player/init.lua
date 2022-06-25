local awful       = require("awful")
local wibox       = require("wibox")
local beautiful   = require("beautiful")
local dpi         = beautiful.xresources.apply_dpi
local gears       = require("gears")
local icons       = require("commons.icons")
local shape_utils = require("commons.shape")
local commands    = require("commons.commands")
local text_format = require("commons.text_format")

player_works = false

local function button(symb, command)
  icon = icons.wbi(symb, 30)
  icon:buttons(gears.table.join(awful.button({ }, 1, command)))
return icon
end

local create_label = function(glyph)
return wibox.widget{
    text   = glyph,
    align = "center",
    opacity = 1,
    font = beautiful.icons_font .. " Bold 16",
    widget = wibox.widget.textbox,
}
end


local create_text = function(glyph)
return wibox.widget{
    text   = glyph,
    opacity = 1,
    font = beautiful.font .. " ExtraBold 16",
    widget = wibox.widget.textbox,
}
end


local create_btn_callback = function(on_play_cmd, on_pause_cmd)
  return function()
    local command = ""

    if player_works then
      command = on_play_cmd
    else
      command = on_pause_cmd
    end

    awful.spawn.with_shell(command)
  end
end


local make_metadata_margin = function(content)
  return {
    content,
    widget = wibox.container.margin,
    left = dpi(5),
    right = dpi(5)
  }
end


local make_hor_layout = function(l, v)
  return {
    make_metadata_margin(l),
    v,
    layout = wibox.layout.fixed.horizontal
  }
end


local make_ctr_margin = function(content)
  return {
    content,
    widget = wibox.container.margin,
    margins = dpi(3)
  }
end

local tittle_label = create_label("")
local album_label = create_label("")
local artist_label = create_label("")

local tittle_val = create_text("Open")
local album_val = create_text("Spotify")
local artist_val = create_text("To Start")


local text_metadata = {
  make_hor_layout(tittle_label, tittle_val),
  make_hor_layout(album_label, album_val),
  make_hor_layout(artist_label, artist_val),
  layout = wibox.layout.fixed.vertical
}

local on_player_pause_cmd = "spotify"

local prv_btn = button("", create_btn_callback(commands.player_prev, on_player_pause_cmd))
local tgl_btn = button("", create_btn_callback(commands.player_toggle, on_player_pause_cmd))
local nxt_btn = button("", create_btn_callback( commands.player_next, on_player_pause_cmd))


local control_panel = {
  make_ctr_margin(prv_btn),
  make_ctr_margin(tgl_btn),
  make_ctr_margin(nxt_btn),
  layout = wibox.layout.flex.horizontal
}


local player = wibox.widget(
{
  {
    {
      {
        {
          {
              id = "art",
              resize_allowed  = true,
              widget = wibox.widget.imagebox,
          },
            widget = wibox.container.background,
            forced_width = dpi(100),
            forced_height = dpi(100),
            id = "art-box"
        },
        margins = dpi(10),
        widget = wibox.container.margin,
      },
      text_metadata,
      layout = wibox.layout.align.horizontal,
    },
    control_panel,
    layout = wibox.layout.flex.vertical,
    id = "body"
  },
  widget = wibox.container.background,
  forced_width = dpi(100),
  forced_height = dpi(200),
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
    tittle_val.text = text_format.shorting(title, 15)
    album_val.text  = text_format.shorting(album, 15)
    artist_val.text = text_format.shorting(artist, 15)
    awful.spawn.easy_async_with_shell("curl -o " .. home_folder .. "/.cache/spotify/current_image " .. art_link,
      function()
        local imbox = player:get_children_by_id("art-box")[1].art
        imbox.image = gears.surface.load_uncached_silently(home_folder .. "/.cache/spotify/current_image")
      end)
    else
      tittle_val.text = "Click"
      album_val.text  = "To start"
      artist_val.text = on_player_pause_cmd
  end

end)

return player
