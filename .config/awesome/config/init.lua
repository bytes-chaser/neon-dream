local shape_utils = require("commons.shape")
local naughty 	  = require("naughty")

cfg = {
	theme = {
		name = "neon-dream-v2",
		cache_file = home_folder .. '/.cache/awesome/themes',
	},
	tags = {
		names = { "web", "dev", "misc"},
		shape = shape_utils.default_frr
	},
	panels = {
		packages = {
			enabled = true,
			names = {
				'git', 'lua', 'awesome-git',
				'alacritty', 'zsh', 'neovim',
				'rofi', 'yay', 'pacman', 'alsa-lib',
				'spotify', 'spicetify-cli', 'systemd',
				'sudo', 'ttf-jetbrains-mono', 'ttf-font-awesome',
				'ranger', 'python', 'pulseaudio', 'playerctl', 'picom'
			},
			cache_file = home_folder .. '/.cache/awesome/packages',
			pagination_defaults = {
				size          = 12,     -- items per page,
				order         = 'asc', -- asc or desc
				sort_property = 1,     -- 1-Name, 3-Current Version, 6-Available version

			},
			style = {
				card_margin   = 7,
			}
		},
		git = {
			--[[
				Packages Required:
				1. git
			]]--
			enabled = false,
			scan_root_path = home_folder,
			cache_file = home_folder .. '/.cache/awesome/repos',
			pagination_defaults = {
				size          = 12,     -- items per page,
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
		docker = {
			--[[
				Packages Required:
				1. docker
			]]--
			enabled = false,
			cache_file = home_folder .. '/.cache/awesome/docker_containers',
			pagination_defaults = {
				size          = 10,    -- items per page,
				order         = 'asc', -- asc or desc
				sort_property = 3,     -- 1-ID, 2-Image, 3-Name, 4-Ports, 5-Status
			},
			style = {
				card_margin   = 5,
			}
		},
		stats = {

			enabled = true,
			version = 'v2' -- v1, v2
		},
		user = {
			--[[
				Packages Required:
				1. spotify
				2. alsa-utils
				3. pulseaudio
				4. amixer
				5. playerctl
				5. brightnessctl

				Action Required:
				1. Setup Weather
					1. Go to www.weatherapi.com and create your account
					2. Export API Key into environment variable WEATHER_API_COM_API_KEY in .profile file
					3. Export Your city location into environment variable WEATHER_API_COM_CITY in .profile file
			]]--
			enabled = false,
		}
	},


	widgets = {

		todo = {
			path = home_folder .. '/.cache/awesome/todo/'
		},

		calendar = {
			week_started_on_sunday = true,
			weekend_days_indexes   = {5, 6},
		}
	}
}

naughty.persistence_enabled = true
naughty.config.defaults.ontop = true
naughty.config.defaults.timeout = 5
naughty.config.defaults.title = "Alert"
naughty.config.defaults.position = "top_right"
