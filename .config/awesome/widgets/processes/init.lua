local awful        = require("awful")
local wibox        = require("wibox")
local process_info = require("widgets.processes.process_info")


local process = {}

process.add_record = function(base, ps_table, index, records_num)
  local children = base.children
  if index <= records_num then
    local line  = children[index + 1]
    local cells = line.children
    local data = ps_table[index]

    line.name.text = data.name
    line.cpu.text  = data.cpu
    line.mem.text  = data.mem

    process.add_record(base, ps_table, index + 1, records_num)
  end
end


process.create = function()

  local record = {}
  record.name  = "Name"
  record.cpu   = "CPU %"
  record.mem   = "Memory %"

  local base = wibox.widget{
    process_info.create(record),
    process_info.create(record),
    process_info.create(record),
    process_info.create(record),
    process_info.create(record),
    process_info.create(record),
    layout = wibox.layout.flex.vertical,
  }

  awesome.connect_signal("sysstat::ps", function(ps_table)
      local index = 1
     process.add_record(base, ps_table, 1, #ps_table)

  end)

  return base
end


return process
