local awful        = require("awful")
local wibox        = require("wibox")
local beautiful    = require("beautiful")
local dpi          = beautiful.xresources.apply_dpi
local gears        = require("gears")
local droplist     = require("widgets.droplist")
local shape_utils  = require("commons.shape")
local icons        = require("commons.icons")
local utils        = require("watchdogs.utils")
local pagination   = require("commons.pagination")
local package_item = require("widgets.packages_list.item")
local paginator    = require("widgets.paginator")

return {
  name = 'packages_list',
  watchdogs = {
      {
          command = [[
              zsh -c "sudo pacman -Sy ; yay -Sy"
            ]],
          interval = 3600,
          callback = function()
              local date_table = os.date("*t")
              local hour, minute, second = date_table.hour, date_table.min, date_table.sec

              local year, month, day = date_table.year, date_table.month, date_table.day   -- date_table.wday to date_table.day
              local result = string.format("%d-%d-%d %d:%d:%d", year, month, day, hour, minute, second, ms)
              awful.spawn.with_shell("echo '" .. result .. "' > " .. home_folder .. '/.cache/awesome/.packages_sync_time')


              utils.procedures.caching(cfg.panels.packages.cache_file, "sysstat::package_add", cfg.panels.packages.names, function(package, callback)
                  local check_updates = "pacman -Qu " .. package .. " | awk '{printf $4}'"
                  local check_current = "pacman -Q "  .. package .. " | awk '{printf $2}'"

                  awful.spawn.easy_async_with_shell(check_updates, function(out)
                      local is_outdated = (#out == 0)
                      local avail_version = is_outdated and '' or out
                      local avail_col = beautiful.palette_positive
                      local avail_font = (is_outdated and '16' or '12')

                      awful.spawn.easy_async_with_shell(check_current, function(version)
                          local color = is_outdated and beautiful.palette_positive or beautiful.palette_negative
                          local line_data = {
                              package:gsub("[\r\n]", ""),
                              color,
                              version:gsub("[\r\n]", ""),
                              avail_col,
                              avail_font,
                              avail_version:gsub("[\r\n]", "")
                          }
                          callback(line_data)
                      end)
                  end)
              end)
          end,
      }
  },

  create = function()

      local scroll = {
          widget = wibox.widget.separator,
          shape  = shape_utils.default_frr,
      }


      local base_widget = wibox.widget({
          layout           = require("dependencies.overflow").vertical,
          spacing          = dpi(5),
          scrollbar_width  = dpi(8),
          step             = 50,
          scrollbar_widget = scroll,
      })


      local page       = 1
      local totalPages = 1
      local size       = cfg.panels.packages.pagination_defaults.size
      local col        = cfg.panels.packages.pagination_defaults.sort_property
      local direction  = cfg.panels.packages.pagination_defaults.order


      local sort_menu = wibox.widget({
          text   = 'Sort by:',
          align = "left",
          opacity = 1,
          font = beautiful.font_famaly .. '10',
          widget = wibox.widget.textbox,
      })


      local toggleOrder = function()
          direction = direction == 'asc' and 'desc' or 'asc'
          return direction == 'asc' and '' or ''
      end


      local updateSortBox = function(n)
          if n == 1 then
              sort_menu.text = 'Sort by: Name'
          elseif n == 3 then
              sort_menu.text = 'Sort by: Current version'
          elseif n == 6 then
              sort_menu.text = 'Sort by: Available version'
          end
      end


      local pgntr


      local update_callback = function(page_body)
          local pacs = page_body.text
          page       = page_body.page
          size       = page_body.size
          totalPages = page_body.totalPages
          col        = page_body.col

          local totalElements = page_body.totalElements

          base_widget:reset()

          for line in pacs:gmatch('([^\n]+)') do
              local arr = nd_utils.split(line, ' ')

              local name      = arr[1]
              local c_color   = arr[2]
              local c_version = arr[3]
              local a_color   = arr[4]
              local a_font    = arr[5]
              local a_version = arr[6]

              base_widget:add(package_item.create(name, c_version, c_color, a_version, a_font, a_color))
          end

          paginator.update(pgntr, page, size, totalElements, totalPages)
          updateSortBox(col)
      end


      local update = function()
          pagination.getPage(cfg.panels.packages.cache_file, update_callback, page, size, col, direction)
      end


      local paginator_prev = function()
          if page > 1 then
              page = page - 1
          end
          update()
      end


      local paginator_next = function()
          if page < totalPages then
              page = page + 1
          end
          update()
      end


      pgntr = paginator.create(10, paginator_prev, paginator_next)


      local sortDirection = icons.wbi(direction == 'asc' and '' or '', 12)
      sortDirection:buttons(gears.table.join(awful.button({ }, 1, function()
          sortDirection.text = toggleOrder()
          update()
      end)))


      awesome.connect_signal("sysstat::package_add", function()
          page = 1
          update()
      end)


      droplist.create(sort_menu,
              shape_utils.partially_rounded_rect(false, true, true, false, beautiful.rounded),
              'right', 'middle',
              {
                  {
                      name = "Name",
                      default = true,
                      callback = function()
                          col = 1
                          update()
                      end,
                  },
                  {
                      name = "Current version",
                      callback = function()
                          col = 3
                          update()
                      end
                  },
                  {
                      name = "Available version",
                      callback = function()
                          col = 6
                          update()
                      end
                  }
              }
      )


      local header_widget = wibox.widget({
          widget = wibox.container.margin,
          margins = dpi(3),
          {
              widget = wibox.container.background,
              forced_height = dpi(35),
              {
                  layout = wibox.layout.align.horizontal,
                  pgntr,
                  nil,
                  {
                      layout = wibox.layout.align.horizontal,
                      sort_menu,
                      {
                          widget = wibox.widget.background,
                          forced_width = 10
                      },
                      sortDirection
                  }
              }
          }
      })


      update();
      return wibox.widget({
          widget = wibox.layout.fixed.vertical,
          header_widget,
          base_widget
      })

  end
}
