---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")

local theme = {}
theme.font_famaly = "JetBrains Mono "
theme.font_size = 10
theme.font        = theme.font_famaly..tostring(theme.font_size)

theme.pallete_c1 = "#ff77ff"
theme.pallete_c2 = "#88ffff"
theme.pallete_c3 = "#1e1e2c"
theme.pallete_c4 = "#ffaaff"
theme.pallete_c5 = "#333170"
theme.palette_c6 = "#2a2939"
theme.palette_c7 = "#33334a"
theme.col_transparent = "#00000000"

theme.bg_normal     = theme.pallete_c3
theme.bg_focus      = theme.pallete_c3
theme.bg_urgent     = theme.pallete_c1
theme.bg_minimize   = "#444444"
theme.bg_systray    = theme.bg_normal
theme.fg_normal     = theme.pallete_c2
theme.fg_focus      = theme.pallete_c4
theme.fg_urgent     = "d61ff0"
theme.fg_minimize   = "#ffffff"

theme.useless_gap   = dpi(5)
theme.border_width  = dpi(2)
theme.border_normal = theme.col_transparent
theme.border_focus  = theme.pallete_c2
theme.border_marked = "#91231c"


theme.profile_pic = home_folder .. "/profile.png"

-- Progreess bar widget settings
theme.pbar_heigth       = 30
theme.pbar_width        = 30
theme.pbar_margin       = 5
theme.pbar_active_color = theme.pallete_c1
theme.pbar_bg_color     = theme.pallete_c5
theme.pbar_icon_size    = 16


-- Battery indicator widget settings
theme.battery_opacity   = 1
theme.battery_alignment = "center"
theme.battery_size      = 60
-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Generate taglist squares:
local taglist_square_size = dpi(0)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = theme_folder.."submenu.png"
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)

theme.icons_font = "Font Awesome 6 Free "

theme.wallpaper = theme_folder.."2/background.png"


theme.rounded = dpi(20)
-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
