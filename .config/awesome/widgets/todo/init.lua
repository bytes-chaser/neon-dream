local awful       = require("awful")
local wibox       = require("wibox")
local beautiful   = require("beautiful")
local dpi         = beautiful.xresources.apply_dpi
local commands    = require("commons.commands")
local shape_utils = require("commons.shape")
local icons       = require("commons.icons")
local gears       = require("gears")
local naughty     = require("naughty")

local todo = {}

todo.create = function()
  local todo_path = cfg.todo.path
  local get_list_cmd = commands.get_files(todo_path)

  local files = {}
  local content = {}

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


  local text_widget = icons.wbi("+", 14)


  local myprompt = awful.widget.prompt {
      prompt = 'Add: ',
      exe_callback = function(input)
      text_widget.visible = true

      if not input or #input == 0 then
      else
        local add_todo_cmd = "echo '" .. input .. "' > " .. todo_path .. tostring(#files + 1)
        naughty.notify{ text = add_todo_cmd}

          awful.spawn.easy_async_with_shell(add_todo_cmd, function(stdout, stderr)
            naughty.notify{ text = stdout}
            update_todo_list()

          end)
      end

    end
  }


  local base_widget = wibox.widget({
    layout = wibox.layout.align.vertical,
    {
      widget = wibox.container.margin,
      bottom = dpi(10),
      {
        myprompt,
        text_widget,
        nil,
        layout = wibox.layout.align.horizontal
      }
    },
    list
  })

  update_todo_list()

  text_widget:buttons(gears.table.join(awful.button({ }, 1, function()
    myprompt:run()
    text_widget.visible = false
  end)))

  return base_widget

end

return todo
