local awful         = require("awful")
local beautiful     = require("beautiful")
local dpi           = beautiful.xresources.apply_dpi
local gears         = require("gears")
local wibox         = require("wibox")
local icons         = require("commons.icons")
local commands      = require("commons.commands")

local controls = require("widgets.player.controls")


local make_ctr_margin = function(content)
  return {
    content,
    widget = wibox.container.margin,
    left   = dpi(5),
    right  = dpi(5),
    buttom = dpi(1),
    top    = dpi(1),
  }
end


local text_player = wibox.widget{
    text    = "Nothing is played",
    align   = "center",
    opacity = 1,
    font    = beautiful.font .. " ExtraBold 10",
    widget  = wibox.widget.textbox,
}


local prv_btn = controls.create("", 10, commands.player_prev)
local tgl_btn = controls.create("", 10, commands.player_toggle)
local nxt_btn = controls.create("", 10, commands.player_next)

  local wibox_player = wibox.widget{
    widget       = wibox.container.background,
    forced_width = dpi(300),
    visible      = false,
    {
      layout = wibox.layout.fixed.vertical,
      {
        layout        = wibox.container.scroll.horizontal,
        max_size      = 100,
        speed         = 100,
        step_function = wibox.container.scroll.step_functions.nonlinear_back_and_forth,
        {
          text_player,
          widget = wibox.container.margin,
          left   = dpi(5),
          right  = dpi(5),
          bottom = dpi(2)
        }
      },
      {
        make_ctr_margin(prv_btn),
        make_ctr_margin(tgl_btn),
        make_ctr_margin(nxt_btn),
        layout = wibox.layout.flex.horizontal,
      }
    }
  }

  awesome.connect_signal("player::metadata",
  function(status, title, album, artist, art_link)

    if status == nil then
      player_works = false
    elseif status:match("Paused") then
      tgl_btn.text = ""
    elseif status:match("Playing") then
      tgl_btn.text = ""
    end

    if player_works then
      text_player.text = title .. " - " .. artist
      wibox_player.visible = true
    else
      text_player.text = "Nothing is played"
      wibox_player.visible = false
    end

  end)

return wibox_player
