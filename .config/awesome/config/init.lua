local shape_utils = require("commons.shape")
local naughty 	  = require("naughty")

cfg = {
	theme = "neon-dream-v2",
	tags = {
		names = { "web", "dev", "misc"},
		shape = shape_utils.default_frr
	},
	track_packages = {
		names = {'git', 'lua', 'awesome-git', 'alacritty', 'zsh', 'neovim', 'rofi'},
		cache_file = home_folder .. '/.cache/awesome/packages',
		pagination_defaults = {
			size          = 6,     -- items per page,
			order         = 'asc', -- asc or desc
			sort_property = 1,     -- 1-Name, 3-Current Version, 6-Available version

		},
		style = {
			card_margin   = 7,
		}
	},
	repos_scan = {
		scan_root_path = home_folder,
		cache_file = home_folder .. '/.cache/awesome/repos',
		pagination_defaults = {
			size          = 5,     -- items per page,
			order         = 'asc', -- asc or desc
			sort_property = 3,     -- 2-Path, 3-Name, 4-Remote URL
		},
		style = {
			card_margin   = 5,
		},
		exclude_paths  = {
			home_folder .. '/.cache/yay/',
			home_folder .. '/.local/share/nvim/'
		}
	},
	calendar = {
		week_started_on_sunday = true,
		weekend_days_indexes   = {5, 6},
	},
	todo = {
		path = home_folder .. '/.cache/awesome/todo/'
	},
	widgets_versions = {
		stat_bar = 'v2' -- v1, v2
	}
}

naughty.persistence_enabled = true
naughty.config.defaults.ontop = true
naughty.config.defaults.timeout = 5
naughty.config.defaults.title = "Alert"
naughty.config.defaults.position = "top_right"
