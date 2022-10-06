local awful     = require("awful")
local beautiful = require("beautiful")

local copy_file_cnt = function(path1, path2)
    local t = io.open(path1, "r")

    if t then
        local theme = t:read("*all")
        local a = io.open(path2, "w")
        if a then
            a:write(theme)
            a:close()
        end
        t:close()
    end
end

local theme_util = {}


theme_util.switch = function(name)
    copy_file_cnt(theme_folder .. name .. '/theme.lua'          , theme_active)
    copy_file_cnt(theme_folder .. name .. '/alacritty.yml'      , alacritty_folder .. 'alacritty.yml')
    copy_file_cnt(theme_folder .. name .. '/config.rasi'        ,rofi_folder .. 'config.rasi')
    copy_file_cnt(theme_folder .. name .. '/background.png'     ,rofi_folder .. 'background.png')

    awful.spawn.easy_async_with_shell("sh " .. theme_folder .. name .. '/spicetify.sh', function()
        awesome.restart()
    end)


end

theme_util.init = function()
    local a = io.open(theme_active, "r")
    if a then
        beautiful.init(theme_active)
    else
        theme_util.switch(cfg.theme.name)
    end
end

return theme_util