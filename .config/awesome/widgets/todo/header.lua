local awful        = require("awful")
local icons        = require("commons.icons")
local gears        = require("gears")
local wibox        = require("wibox")

return {

  create = function(prompt_callback)
    local btn = icons.wbi("+", 14)

    local myprompt = awful.widget.prompt {
        prompt = 'Add: ',
        exe_callback = prompt_callback,
        done_callback = function()
          btn.visible = true
        end
    }

    btn:buttons(gears.table.join(awful.button({ }, 1, function()
      myprompt:run()
      btn.visible = false
    end)))

    return {
      myprompt,
      btn,
      nil,
      layout = wibox.layout.align.horizontal
    }
  end
}
