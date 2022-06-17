local awful         = require("awful")
local beautiful     = require("beautiful")
local dpi           = beautiful.xresources.apply_dpi
local gears         = require("gears")
local wibox         = require("wibox")
local icons         = require("commons.icons")
local commands      = require("commons.commands")
local text_format   = require("commons.text_format")

local text_player = wibox.widget{
    text   = "Nothing is played",
    align = "center",
    opacity = 1,
    font = beautiful.font .. " ExtraBold 10",
    widget = wibox.widget.textbox,
}

local function button(symb, command)
  icon = icons.wbi(symb, 12)
  icon:buttons(gears.table.join(
      awful.button({ }, 1, command)))
  return icon
end

local prev_btn = button("", function()
  local command = ""

  if player_works then
    command = commands.player_prev
  else
    command = "spotify"
  end

  awful.spawn.with_shell(command)
end)

local toggle_btn = button("", function()
    local command = ""
    if player_works then
      command = commands.player_toggle
    else
      command = "spotify"
    end
    awful.spawn.with_shell(command)
  end)


local next_btn = button("", function()
    local command = ""
    if player_works then
      command = commands.player_next
    else
      command = "spotify"
    end
    awful.spawn.with_shell(command)
  end)

  local wibox_player = wibox.widget{
    widget = wibox.container.background,
    forced_width = dpi(300),
    visible = false,
    {
      layout = wibox.layout.fixed.vertical,
      {
        text_player,
        widget = wibox.container.margin,
        left = dpi(5),
        right = dpi(5),
        bottom = dpi(2)
      },
      {
        {
          prev_btn,
          widget = wibox.container.margin,
          left = dpi(5),
          right = dpi(5),
        },
        {
          toggle_btn,
          widget = wibox.container.margin,
          left = dpi(5),
          right = dpi(5),
        },
        {
          next_btn,
          widget = wibox.container.margin,
          left = dpi(5),
          right = dpi(5),
        },
        layout = wibox.layout.flex.horizontal,
      }
    }
  }

  awesome.connect_signal("player::metadata",
  function(status, title, album, artist, art_link)

    if status == nil then
      player_works = false
    elseif status:match("Paused") then
      toggle_btn.text = ""
    elseif status:match("Playing") then
      toggle_btn.text = ""
    end

    if player_works then
      text_player.text = text_format.shorting(title .. " - " .. artist, 35)
      wibox_player.visible = true
    else
      text_player.text = "Nothing is played"
      wibox_player.visible = false
    end

  end)

return wibox_player
