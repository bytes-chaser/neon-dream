local awful    = require('awful')
local commands = require('commons.commands')


local function caching(cache_file, signal, data_table, single_item_processor, full_text, index)
    awful.spawn.with_shell(commands.create_text_file(cache_file))

    local size = #data_table;
    local single_item = data_table[index]

    single_item_processor(single_item, function(line_data)
        local row = table.concat(line_data, " ") .. '\n'
        full_text = full_text .. row

        if index == size then
            awful.spawn.easy_async_with_shell(commands.append_text(cache_file, full_text), function() awesome.emit_signal(signal) end)
        else
            caching(cache_file, signal, data_table, single_item_processor, full_text,index + 1)
        end
    end)
end


return {
    procedures = {
         caching = function(cache_file, signal, data_table, single_item_processor)
             return caching(cache_file, signal, data_table, single_item_processor, '', 1)
         end
    }
}