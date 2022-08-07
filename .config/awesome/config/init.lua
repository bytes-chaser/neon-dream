local shape_utils = require("commons.shape")
local naughty 	  = require("naughty")

cfg = {
	theme_version = "2",
	tags = {
		names = { "web", "dev", "misc"},
		shape = shape_utils.default_frr
	},
	track_packages = {'git', 'lua', 'awesome-git', 'alacritty', 'zsh', 'python', 'go'},
	repos_scan = {
		scan_root_path = home_folder,
		exclude_paths  = {
			home_folder .. '/.cache/yay/',
			home_folder .. '/.local/share/nvim/'
		}
	},
	calendar = {
		week_started_on_sunday = true,
		weekend_days_incices   = {5, 6},
	},
	todo = {
		path = home_folder .. '/.cache/awesome/todo/'
	}
}

naughty.persistence_enabled = true
naughty.config.defaults.ontop = true
naughty.config.defaults.timeout = 5
naughty.config.defaults.title = "Alert"
naughty.config.defaults.position = "top_right"
