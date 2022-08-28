local beautiful    = require("beautiful")
local wibox        = require("wibox")
local process_info = require("widgets.processes.process_info")


local process = {}

process.add_record = function(base, ps_table, index, records_num)
  local children = base.children
  if index <= records_num then
    local line  = children[index + 1]
    local data = ps_table[index]

    line.marg.i_marg.box.name.markup = "<span foreground='" .. beautiful.pallete_c2 .."'>" .. data.name  .."</span>"
    line.marg.i_marg.box.cpu.markup  = "<span foreground='" .. beautiful.pallete_c2 .."'>" .. data.cpu  .."</span>"
    line.marg.i_marg.box.mem.markup  = "<span foreground='" .. beautiful.pallete_c2 .."'>" .. data.mem  .."</span>"
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
    process_info.create(record),
    process_info.create(record),
    layout = wibox.layout.fixed.vertical,
  }

  awesome.connect_signal("sysstat::ps", function(ps_table)
      local index = 1
     process.add_record(base, ps_table, 1, #ps_table)

  end)

  return base
end


return process
