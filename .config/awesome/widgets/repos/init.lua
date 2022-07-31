local awful       = require("awful")
local wibox       = require("wibox")
local beautiful   = require("beautiful")
local dpi         = beautiful.xresources.apply_dpi
local commands    = require("commons.commands")
local shape_utils = require("commons.shape")
local icons       = require("commons.icons")

local repos = {}

repos.create = function()


  local base = {
		layout = require("dependencies.overflow").vertical,
		spacing = dpi(5),
		scrollbar_widget = {
			widget = wibox.widget.separator,
			shape = shape_utils.partially_rounded_rect(beautiful.rounded, true, true, true, true),
		},
		scrollbar_width = dpi(8),
		step = 50,
	}


  local base_widget = wibox.widget(base)


  awesome.connect_signal("sysstat::git_repos", function(repos)

    for k, repo_info in pairs(repos) do
      local path = repo_info.path
      awful.spawn.easy_async_with_shell(commands.git_repo_info(path), function(out)
        local url = out:match('Fetch URL: (.+)%.git\n%s+Push')

        local source_icon = ""

        if url:find('github') then
          source_icon = ''
        elseif url:find('gitlab') then
          source_icon = ""
        elseif url:find('bitbucket') then
          source_icon = ""
        end

        base_widget:add(
        {
          {
            {
              {
                {
                  icons.wbi(repo_info.icon, 16),
                  {
                    {
                      id = "name",
                      widget = wibox.widget.textbox,
                      markup   = "<span foreground='" .. beautiful.fg_focus .."'>" .. repo_info.name .."</span>",
                      font = beautiful.font_famaly .. '12',
                    },
                    widget = wibox.container.margin,
                    left = dpi(20)
                  },
                  nil,
                  layout = wibox.layout.align.horizontal
                },
                {
                  icons.wbi("", 14),
                  {
                    {
                      id = "path",
                      widget = wibox.widget.textbox,
                      markup   = "<span foreground='" .. beautiful.fg_normal .."'>" .. repo_info.path .."</span>",
                      font = beautiful.font_famaly .. '10',
                    },
                    widget = wibox.container.margin,
                    left = dpi(20)
                  },
                  layout = wibox.layout.align.horizontal
                },
                {
                  icons.wbi(source_icon, 14),
                  {
                    wibox.widget {
                       layout = wibox.container.scroll.horizontal,
                       max_size = 100,
                       step_function = wibox.container.scroll.step_functions
                                       .nonlinear_back_and_forth,
                       speed = 100,
                       {
                         id = "remote",
                         wrap = 'word_char',
                         widget = wibox.widget.textbox,
                         markup   = "<span foreground='" .. beautiful.fg_normal .."'>" .. url .."</span>",
                         font = beautiful.font_famaly .. '10',
                       },
                    },

                    widget = wibox.container.margin,
                    left = dpi(20)
                  },
                  layout = wibox.layout.align.horizontal
                },
                layout = wibox.layout.flex.vertical
              },
              widget = wibox.container.margin,
              margins = dpi(10)
            },
            layout = require("dependencies.overflow").vertical,
            spacing = dpi(5),
            scrollbar_widget = {
              widget = wibox.widget.separator,
              shape = shape_utils.partially_rounded_rect(beautiful.rounded, true, true, true, true),
            },
            scrollbar_width = dpi(8),
            step = 50,
          },
          widget = wibox.container.background,
          bg = beautiful.palette_c7,
        }
      )
      end)

    end
  end)

  return base_widget

end

return repos
