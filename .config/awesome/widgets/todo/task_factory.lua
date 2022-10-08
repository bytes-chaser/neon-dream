local awful       = require("awful")
local commands    = require("commons.commands")
local gears       = require("gears")
local btn         = require('widgets.todo.delete_btn')
local task        = require('widgets.todo.task')

return {
  create = function(todo_path, file, text, delete_callback)

    local delete_btn = btn.create()
    delete_btn:buttons(gears.table.join(awful.button({ }, 1, function()
      local delete_file_cmd = commands.delete_file(todo_path .. file)
      awful.spawn.easy_async_with_shell(delete_file_cmd, function()
        delete_callback()
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
