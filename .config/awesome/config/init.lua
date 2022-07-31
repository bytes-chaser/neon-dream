local shape_utils = require("commons.shape")
local beautiful   = require("beautiful")
local naughty 	  = require("naughty")

cfg = {
	theme_version = "2",
	tags = { "web", "dev", "misc"},
	tags_shape = shape_utils.partially_rounded_rect(beautiful.rounded, true, true, true, true),
	track_packages = {'git', 'lua', 'awesome-git', 'alacritty', 'zsh', 'python', 'go'},
	repos_scan = {
		scan_root_path = home_folder,
		exclude_paths = {
			home_folder .. '/.cache/yay/',
			home_folder .. '/.local/share/nvim/'
		}
	},
	todo ={
		path = home_folder .. '/.cache/awesome/todo/'
	}
}

naughty.persistence_enabled = true
naughty.config.defaults.ontop = true
naughty.config.defaults.timeout = 5
naughty.config.defaults.title = "Alert"
naughty.config.defaults.position = "top_right"
