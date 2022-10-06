local awful    = require("awful")
local commands = require("commons.commands")

return {
    getPage = function(path, callback, page, size, col, order)
        if size == nil then
            size = 10
        end

        local get_text_cmd = commands.get_text(path)

        if col then

            if order == nil then
                order = 'asc'
            end

            get_text_cmd = commands.get_text_sorted(path, col, order)
        end

        local get_count = get_text_cmd .. ' | wc -l'


        awful.spawn.easy_async_with_shell(get_count, function(out)
            local count       = tonumber(out)
            local totalPages  = math.floor(count / size)
            local diff        = count % size

            if diff > 0 then
                totalPages = totalPages + 1
            end


            if page > totalPages then
                page = totalPages
            end

            if page < 1 then
                page = 1
            end


            local cmd  = get_text_cmd .. ' | head -' .. tostring(page * size) .. ' | tail -'
                    .. tostring((page == totalPages and diff > 0) and diff or size)

            awful.spawn.easy_async_with_shell(cmd, function(text)
                callback({
                    text          = text,
                    is_last       = totalPages == page,
                    is_first      = page == 1,
                    page          = page,
                    size          = size,
                    col           =  col,
                    totalElements = count,
                    totalPages    = totalPages
                })
            end)
        end)

    end
}