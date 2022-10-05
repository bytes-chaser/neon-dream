local awful       = require("awful")
local wibox       = require("wibox")
local beautiful   = require("beautiful")
local dpi         = beautiful.xresources.apply_dpi
local gears       = require("gears")
local commands    = require("commons.commands")
local icons       = require("commons.icons")
local shape_utils = require("commons.shape")
local droplist    = require("widgets.droplist")
local pagination   = require("commons.pagination")
local paginator   = require("widgets.paginator")

local container_card   = require("widgets.docker_containers.docker_container_card")

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
        local size       = cfg.docker.pagination_defaults.size
        local col        = cfg.docker.pagination_defaults.sort_property
        local direction  = cfg.docker.pagination_defaults.order


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
                sort_menu.text = 'Sort by: ID'
            elseif n == 2 then
                sort_menu.text = 'Sort by: Image'
            elseif n == 3 then
                sort_menu.text = 'Sort by: Name'
            elseif n == 4 then
                sort_menu.text = 'Sort by: Ports'
            elseif n == 5 then
                sort_menu.text = 'Sort by: Status'
            end
        end

        local pgntr;

        local update_callback = function(page_body)
            local containers = page_body.text
            page       = page_body.page
            size       = page_body.size
            totalPages = page_body.totalPages
            col        = page_body.col

            local totalElements = page_body.totalElements

            base_widget:reset()

            for line in containers:gmatch('([^\n]+)') do
                local arr = nd_utils.split(line, ' ')

                local id      = arr[1]
                local image   = arr[2]
                local name    = arr[3]
                local ports   = arr[4]
                local status  = arr[5]
                local time    = arr[6]

                base_widget:add(container_card.create(id, image, name, ports, status, time))
            end

            paginator.update(pgntr, page, size, totalElements, totalPages)
            updateSortBox(col)
        end


        local update = function()
            pagination.getPage(cfg.docker.cache_file, update_callback, page, size, col, direction)
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
                        name = "ID",
                        callback = function()
                            col = 1
                            update()
                        end,
                    },
                    {
                        name = "Image",
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
                        name = "Ports",
                        callback = function()
                            col = 4
                            update()
                        end
                    },
                    {
                        name = "Status",
                        callback = function()
                            col = 5
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


        awesome.connect_signal("sysstat::docker_container_add", function()
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
