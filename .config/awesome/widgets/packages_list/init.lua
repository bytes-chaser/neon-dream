local awful        = require("awful")
local wibox        = require("wibox")
local beautiful    = require("beautiful")
local dpi          = beautiful.xresources.apply_dpi
local gears        = require("gears")
local droplist     = require("widgets.droplist")
local shape_utils  = require("commons.shape")
local icons        = require("commons.icons")
local pagination   = require("commons.pagination")
local package_item = require("widgets.packages_list.item")
local paginator    = require("widgets.paginator")

return {
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
      local size       = cfg.track_packages.pagination_defaults.size
      local col        = cfg.track_packages.pagination_defaults.sort_property
      local direction  = cfg.track_packages.pagination_defaults.order


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
          pagination.getPage(cfg.track_packages.cache_file, update_callback, page, size, col, direction)
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
