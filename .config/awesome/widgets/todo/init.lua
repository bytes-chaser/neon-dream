local awful       = require("awful")
local wibox       = require("wibox")
local beautiful   = require("beautiful")
local dpi         = beautiful.xresources.apply_dpi
local commands    = require("commons.commands")
local shape_utils = require("commons.shape")
local icons       = require("commons.icons")
local gears       = require("gears")

local todo = {}

todo.create = function()

  local list = wibox.widget({
    layout = require("dependencies.overflow").vertical,
    spacing = dpi(8),
    scrollbar_widget = {
      widget = wibox.widget.separator,
      shape = shape_utils.partially_rounded_rect(beautiful.rounded, true, true, true, true),
    },
    scrollbar_width = dpi(8),
    step = 50,
  })

  local text_widget = icons.wbi("+", 14)

  local base_widget = wibox.widget({
    layout = wibox.layout.align.vertical,
    {
      widget = wibox.container.margin,
      bottom = dpi(10),
      text_widget
    },
    list
  })

  local todo_path = cfg.todo.path
  local get_list_cmd = commands.get_files(todo_path)

  local files = {}
  local content = {}

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

            local delete_btn = wibox.widget{
              widget = wibox.container.margin,
              margins = dpi(5),
              icons.wbi("", 10),
              opacity = 0
            }

            local todo_task = wibox.widget({
              {
                widget = wibox.container.margin,
                margins = dpi(10),
                {
                  {
                    widget = wibox.widget.textbox,
                    text   = text_out,
                    font = beautiful.font_famaly .. '10',
                  },
                  nil,
                  {

                    delete_btn,
                    layout = wibox.layout.fixed.horizontal
                  },
                  layout = wibox.layout.align.horizontal
                }
              },
              widget = wibox.container.background,
              bg = beautiful.pallete_c3 .. '77'
            })

            delete_btn:buttons(gears.table.join(awful.button({ }, 1, function()
              local delete_file_cmd = commands.delete_file(todo_path .. file)
              awful.spawn(delete_file_cmd)
              update_todo_list()
            end)))

            todo_task:connect_signal('mouse::enter', function ()
                delete_btn.opacity = 1
            end)

            todo_task:connect_signal('mouse::leave', function ()
                delete_btn.opacity = 0
              end)

            list:add(todo_task)


         end)
      end
    end)
  end

  update_todo_list()

  text_widget:buttons(gears.table.join(awful.button({ }, 1, function()
    awful.spawn.easy_async_with_shell(editor_cmd .. ' ' .. todo_path .. tostring(#files + 1), function()
      update_todo_list()
    end)
  end)))

  return base_widget

end

return todo
