local awful       = require("awful")
local commands    = require("commons.commands")
local gears       = require("gears")
local btn         = require('widgets.todo.delete_btn')
local task        = require('widgets.todo.task')

local function move_files_arr_right(todo_path, index, delete_callback, total)
  local next = index + 1;
  if next <= total then
    local cmd = commands.mv(todo_path .. tostring(next), todo_path .. tostring(index))
    awful.spawn.easy_async_with_shell(cmd, function()
      move_files_arr_right(todo_path, next, delete_callback, total)
    end)
  else
    delete_callback()
  end
end

return {
  create = function(todo_path, file, text, delete_callback, total)

    local delete_btn = btn.create()
    delete_btn:buttons(gears.table.join(awful.button({ }, 1, function()
      local delete_file_cmd = commands.delete_file(todo_path .. file)
      awful.spawn.easy_async_with_shell(delete_file_cmd, function()
        local index = tonumber(file)
        move_files_arr_right(todo_path, index, delete_callback, total)
      end)
    end)))

    local todo_task = task.create(text, delete_btn)

    todo_task:connect_signal('mouse::enter', function ()
        delete_btn.opacity = 1
    end)

    todo_task:connect_signal('mouse::leave', function ()
        delete_btn.opacity = 0
    end)

    return todo_task
  end
}
