local awful       = require("awful")
local wibox       = require("wibox")
local beautiful   = require("beautiful")
local dpi         = beautiful.xresources.apply_dpi
local gears       = require("gears")
local icons       = require("commons.icons")
local shape_utils = require("commons.shape")
local spotify     = require("commons.spotify")



local player_works = false



local function button(symb, command)
  icon = icons.wbi(symb, 30)
  icon:buttons(gears.table.join(
      awful.button({ }, 1, command)))
  return icon
end

local function create_label(glyph)
  return wibox.widget{
      text   = glyph,
      align = "center",
      opacity = 1,
      font = beautiful.icons_font .. " Bold 16",
      widget = wibox.widget.textbox,
  }
end


local function create_text(glyph)
  return wibox.widget{
      text   = glyph,
      opacity = 1,
      font = beautiful.font .. " ExtraBold 16",
      widget = wibox.widget.textbox,
  }
end

local tittle_label = create_label("")
local album_label = create_label("")
local artist_label = create_label("")

local tittle_val = create_text("Open")
local album_val = create_text("Spotify")
local artist_val = create_text("To Start")



local text_metadata = {
  {
    {
      tittle_label,
      widget = wibox.container.margin,
      margins = dpi(5)

    },
    tittle_val,
    layout = wibox.layout.fixed.horizontal
  },
  {
    {
      album_label,
      widget = wibox.container.margin,
      margins = dpi(5)

    },
    album_val,
    layout = wibox.layout.fixed.horizontal
  },
  {
    {
      artist_label,
      widget = wibox.container.margin,
      margins = dpi(5)

    },
    artist_val,
    layout = wibox.layout.fixed.horizontal
  },
  layout = wibox.layout.fixed.vertical
}


local toggle_btn = button("", function()
    local command = ""
    if player_works then
      command = spotify.commands.toggle
    else
      command = "spotify"
    end
    awful.spawn.easy_async(command,
    function(stdout, stderr, reason, exit_code)
    end)
  end)



local control_panel = {
  {
      button("", function()
        local command = ""
        if player_works then
          command = spotify.commands.prev
        else
          command = "spotify"
        end
        awful.spawn.easy_async(command,
        function(stdout, stderr, reason, exit_code)
        end)
      end),
      widget = wibox.container.margin,
      left = dpi(5),
      right = dpi(5)
  },
  {
      toggle_btn,
      widget = wibox.container.margin,
      left = dpi(5),
      right = dpi(5)
  },
  {
      button("", function()
        local command = ""
        if player_works then
          command = spotify.commands.next
        else
          command = "spotify"
        end
        awful.spawn.easy_async(command,
        function(stdout, stderr, reason, exit_code)
        end)
      end),
      widget = wibox.container.margin,
      left = dpi(5),
      right = dpi(5)

  },
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

local function shorting(text)
  if #text > 30 then
    text = text:sub(1, 27) .. "..."
  end
  return text
end
awesome.connect_signal("player::metadata",
function(status, title, album, artist, art_link)

  if status == nil then
    player_works = false
  elseif status:match("Paused") then
    toggle_btn.text = ""
    player_works = true
  elseif status:match("Playing") then
    toggle_btn.text = ""
    player_works = true
  end

  if player_works then
    tittle_val.text = shorting(title)
    album_val.text = shorting(album)
    artist_val.text = shorting(artist)
    awful.spawn.easy_async_with_shell("curl -o " .. home_folder .. "/.cache/spotify/current_image " .. art_link,
      function()
        local imbox = player:get_children_by_id("art-box")[1].art
        imbox.image = gears.surface.load_uncached_silently(home_folder .. "/.cache/spotify/current_image")
      end)
    else
      tittle_val.text = "Open"
      album_val.text = "Spotify"
      artist_val.text = "To Start"
  end

end)

return player
