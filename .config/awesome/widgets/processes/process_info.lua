local wibox = require("wibox")

local pi = {}

pi.create = function(record)
  local name = record.name
  local cpu  = record.cpu
  local mem  = record.mem

  return wibox.widget{
    {
      id = "name",
      widget = wibox.widget.textbox,
      text = name
    },
    {
      id = "cpu",
      widget = wibox.widget.textbox,
      text = cpu
    },
    {
      widget = wibox.widget.textbox,
      id = "mem",
      text = mem
    },
    layout = wibox.layout.flex.horizontal,
  }
end

return pi
