local awful        = require("awful")
local wibox        = require("wibox")
local beautiful    = require("beautiful")
local dpi          = beautiful.xresources.apply_dpi
local commands     = require("commons.commands")

local task_factory = require("widgets.todo.task_factory")
local add_btn      = require("widgets.todo.add_btn")
local header       = require("widgets.todo.header")

local todo = {}
local todo_path = cfg.todo.path
local get_list_cmd = commands.get_files(todo_path)

return {
  create = function()

    local files = {}
    local content = {}

    local list = require('widgets.todo.list')

    update_todo_list = function()
      list:reset()
      files = {}
      content = {}

      awful.spawn.easy_async_with_shell(get_list_cmd, function(stdout)
        local index = 1
        for w in stdout:gmatch("[^\r\n]+") do
          files[index] = w
          index = index + 1
        end


        for i = 1, #files do
           local file = files[i]
           local read_cmd = commands.get_text(todo_path .. file)
           awful.spawn.easy_async_with_shell(read_cmd, function(text_out, stderr, reason, exit_code)
              content[i] = text_out
              local task = task_factory.create(todo_path, file, text_out, update_todo_list)
              list:add(task)
           end)
        end
      end)
    end


    local prompt_callback = function(input)
      if not input or #input == 0 then
      else
        local add_todo_cmd = "echo '" .. input .. "' > " .. todo_path .. tostring(#files + 1)
          awful.spawn.easy_async_with_shell(add_todo_cmd, update_todo_list)
      end

    end


    local base_widget = wibox.widget({
      layout = wibox.layout.align.vertical,
      {
        widget = wibox.container.margin,
        bottom = dpi(10),
        header.create(prompt_callback, update_todo_list)
      },
      list
    })

    update_todo_list()

    return base_widget

  end
}
