local awful       = require("awful")
local wibox       = require("wibox")
local beautiful   = require("beautiful")
local dpi         = beautiful.xresources.apply_dpi
local gears       = require("gears")
local utils       = require("watchdogs.utils")
local commands    = require("commons.commands")
local icons       = require("commons.icons")
local shape_utils = require("commons.shape")
local droplist    = require("widgets.droplist")
local pagination  = require("commons.pagination")
local paginator   = require("widgets.paginator")

local repo_card   = require("widgets.repos.repo_card")

local check_excluded_repo_path = function(w)

  for _, path in pairs(cfg.panels.git.exclude_paths) do
    if w:find(path) then
      return false
    end
  end

  return true
end

return {
  name = 'repos',
  watchdogs = {
    {
      command = commands.git_repos(cfg.panels.git.scan_root_path),
      interval = 3600,
      callback = function(widget, stdout)

        local lines = {}
        for w in stdout:gmatch("[^\r\n]+") do
          local included = check_excluded_repo_path(w)
          if included then
            table.insert(lines, w)
          end
        end

        utils.procedures.caching(cfg.panels.git.cache_file, "update::repos", lines, function(item, callback)
          local path = item:match('(.*)/.git')

          awful.spawn.easy_async_with_shell(commands.git_repo_info(path), function(out)
            local url = out:match('Fetch URL: (.+)%.git\n%s+Push') or 'undefined'

            local source_icon = ""

            if(url == nil) then
              source_icon = ""
            elseif url:find('github') then
              source_icon = ''
            elseif url:find('gitlab') then
              source_icon = ""
            elseif url:find('bitbucket') then
              source_icon = ""
            end

            local formatted_path = string.gsub(path, home_folder, "~")
            local line_data = {
              'git',
              formatted_path,
              path:match('.+/(.+)$'),
              url,
              '',
              source_icon
            }
            callback(line_data)
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
    local size       = cfg.panels.git.pagination_defaults.size
    local col        = cfg.panels.git.pagination_defaults.sort_property
    local direction  = cfg.panels.git.pagination_defaults.order


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
      if n == 2 then
        sort_menu.text = 'Sort by: Path'
      elseif n == 3 then
        sort_menu.text = 'Sort by: Name'
      elseif n == 4 then
        sort_menu.text = 'Sort by: Remote URL'
      end
    end

    local pgntr;

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

        local path        = arr[2]
        local name        = arr[3]
        local url         = arr[4]
        local icon_vcs    = arr[5]
        local icon_remote = arr[6]

        base_widget:add(repo_card.create(path, name, url, icon_vcs, icon_remote))
      end

      paginator.update(pgntr, page, size, totalElements, totalPages)
      updateSortBox(col)
    end


    local update = function()
      pagination.getPage(cfg.panels.git.cache_file, update_callback, page, size, col, direction)
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



    droplist.create(sort_menu,
            shape_utils.partially_rounded_rect(false, true, true, false, beautiful.rounded),
            'right', 'middle',
            {
              {
                name = "Path",
                callback = function()
                  col = 2
                  update()
                end,
              },
              {
                name = "Name",
                default = true,
                callback = function()
                  col = 3
                  update()
                end
              },
              {
                name = "Remote URL",
                callback = function()
                  col = 4
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


    awesome.connect_signal("update::repos", function()
      page = 1
      update()
    end)

    update();

    return wibox.widget({
      widget = wibox.layout.fixed.vertical,
      header_widget,
      base_widget
    })

  end
}
