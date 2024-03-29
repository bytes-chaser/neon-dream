<h1 align="center">Neon Dream</h1>
<p align="center">
  Awesome Windows Manager setup
</p>
<br>

<img width="50%" align="right" src="https://github.com/bytes-chaser/dotfiles/blob/main/assets/neon-2.0/collage.png" />

## :flashlight: Dependencies Information
<table>
  <tr>
    <td><b>Latest Release</b></td>
    <td><a href="https://github.com/bytes-chaser/neon-dream/releases/tag/2.3.0" target="_blank">2.3.0</a></td>
  <tr>
  <tr>
    <td><b>OS</b></td>
    <td><a href="https://archlinux.org/" target="_blank">Arch Linux</a></td>
  <tr>
  <tr>
    <td><b>Display Server</b></td>
    <td><a href="https://www.x.org/" target="_blank">X11</a></td>
  <tr>
  <tr>
    <td><b>Windoiws Compositor</b></td>
    <td><a href="https://github.com/yshui/picom" target="_blank">picom</a></td>
  <tr>
  <tr>
    <td><b>Windows Manager</b></td>
    <td><a href="https://awesomewm.org/" target="_blank">Awesome</a></td>
  <tr>
  <tr>
    <td><b>Terminal</b></td>
    <td><a href="https://github.com/alacritty/alacritty" target="_blank">Alacritty</a></td>
  <tr>
  <tr>
    <td><b>Shell</b></td>
    <td><a href="https://www.zsh.org/" target="_blank">zsh</a></td>
  <tr>
    <tr>
    <td><b>Prompt</b></td>
    <td><a href="https://spaceship-prompt.sh/" target="_blank">Spaceship</a></td>
  <tr>
    <tr>
    <td><b>Apps Launcher</b></td>
    <td><a href="https://github.com/davatorium/rofi" target="_blank">rofi</a></td>
  <tr>
  <tr>
    <td><b>System Info</b></td>
    <td><a href="https://github.com/anhsirk0/fetch-master-6000" target="_blank">fm6000</a></td>
  <tr>
  <tr>
    <td><b>Files Manager</b></td>
    <td><a href="https://github.com/ranger/ranger" target="_blank">ranger</a></td>
  <tr>
  <tr>
    <td><b>Editor</b></td>
    <td><a href="https://neovim.io/" target="_blank">nvim</a></td>
  <tr>
  <tr>
    <td><b>Browser</b></td>
    <td><a href="https://www.mozilla.org" target="_blank">Firefox</a></td>
  <tr>
  <tr>
    <td><b>Player</b></td>
    <td><a href="https://www.spotify.com/us/" target="_blank">Spotify</a></td>
  <tr>
  <tr>
    <td><b>Visualizer</b></td>
    <td><a href="https://github.com/karlstav/cava" target="_blank">cava</a></td>
  <tr>
  <tr>
    <td><b>Text Font</b></td>
    <td><a href="https://www.jetbrains.com/lp/mono/" target="_blank">JetBrains Mono</a></td>
  <tr>
  <tr>
    <td><b>Icons Font</b></td>
    <td><a href="https://fontawesome.com/icons" target="_blank">Font Awesome 6 Free</a></td>
  <tr>

</table>


## :wrench: Additional Information

### zsh
Confugured with [oh-my-zsh](https://ohmyz.sh/) framework and using [Starship Prompt](https://spaceship-prompt.sh/)

### Spotify
Spotify client customized using [spicetify](https://github.com/spicetify/spicetify-cli). Client using [Dribbblish](https://github.com/spicetify/spicetify-themes/tree/master/Dribbblish) theme with a [custom color scheme](https://github.com/bytes-chaser/dotfiles/tree/main/.config/spicetify/Themes/Dribbblish)

### nvim
nvim configuration icnludes plugins configuration using:
* [packer](https://github.com/wbthomason/packer.nvim)
* [vim-plug](https://github.com/junegunn/vim-plug)

#### packer plugins
* [Neon theme](https://github.com/rafamadriz/neon)

#### vim-plug plugins
* [airline](https://github.com/vim-airline/vim-airline')
* [nerdtree](https://github.com/preservim/nerdtree)


### Firefox
* Has [custom color theme](https://github.com/bytes-chaser/dotfiles/tree/main/.config/firefox/themes). 
* Website pages styled with firefox [stylish](https://addons.mozilla.org/en-US/firefox/addon/stylish/) plugin
* [Windowed](https://addons.mozilla.org/en-US/firefox/addon/windowed/) plugin used to for in-window fullscreen mode 

## :mag_right: Awesome
Awesome configuration based on default awesome config. All lua widgets are custom-made.

### Dependencies
<table>
  <tr>
    <td><b>zsh</b></td>
    <td>default shell</a></td>
  <tr>
  <tr>
    <td><b>rofi</b></td>
    <td>Keybindings includes rofi calls</a></td>
  <tr>
  <tr>
    <td><b>flameshot</b></td>
    <td>Keybindings includes flameshot calls for making screenshots</a></td>
  <tr>
  <tr>
    <td><b>playerctl</b></td>
    <td>Used for player widgets implementations</a></td>
  <tr>
</table>


### Decorations
By default decorations are hidden. To toggle active client decorations visibility use **Mod + T** key binding. It will not affect other opened clients and  new clients. **Mod  + Ctrl + T** key binding will toggle decoration visibility for all opened and new spawned clients 
Decorations buttons has 5 buttons. Each of them has icon that becoming visible on hover. For last 4 buttons icon can changing depending on client state.
Buttons:
1. Close
2. Maximize/Unmaximize
3. Toggle floating mode
4. Toggle sticky
5. Toggle ontop


![](https://github.com/bytes-chaser/dotfiles/blob/main/assets/neon-2.0/decorations.png)

### Main Bar
Transparent bar with rounded widget subsections.
![](https://github.com/bytes-chaser/dotfiles/blob/main/assets/neon-2.0/bar.png)
Includes:
* Tag Switch
* Left Bar Switch
* Active Client Title (Becomes visible on any client focus)
* Bar player  (Becomes visible on playing music/video only)
* CPU usage history graph
* RAM usage history graph
* Systray (includes battery, theme switcher and notifications widgets)

### Battery
Battery icon on systray shows battery charge level on hover event. Icon is changing depends on battery charge level.
Battery click event triggers shutdown popup menu to open

![](https://github.com/bytes-chaser/dotfiles/blob/main/assets/neon-2.0/shutdown.png)

### Notifications
Notification icon on systray. On click triggers notification menu to open

![](https://github.com/bytes-chaser/dotfiles/blob/main/assets/neon-2.0/notifications.png)

### Packages bar
Packages bar can be opened on left screen side by selecting it on Left Bar Switch or with keybinding  **Mod + Shift + z**
It shows synchronization status of packages with pacman/aur repositories. 
Information splited on pages and can be sorted in by Name, Current Version and Available Version in any direction
List of packages, pagination etc. can be configured in **cfg/init.lua  track_packages** 

![](https://github.com/bytes-chaser/dotfiles/blob/main/assets/neon-2.0/pacs.png)

### Repos bar
Repos bar can be opened on left screen side by selecting it on Left Bar Switch or with keybinding  **Mod + Shift + g**
It shows Git repositories on your system.
Information splited on pages and can be sorted in by Name, Path, Remote URL in any direction
Pagination can be configured in **cfg/init.lua  docker** 

![](https://github.com/bytes-chaser/dotfiles/blob/main/assets/neon-2.0/repos.png)

### Docker bar
Docker bar can be opened on left screen side by selecting it on Left Bar Switch or with keybinding  **Mod + Shift + d**
It shows docker containers status.
Information splited on pages and can be sorted in by Name, ID, Image, Ports, Status in any direction
Scan path, pagination etc. can be configured in **cfg/init.lua  repos_scan** 

![](https://github.com/bytes-chaser/dotfiles/blob/main/assets/neon-2.0/docker_showcase.png)

### User bar
User bar can be opened on left screen side by selecting it on Left Bar Switch or with keybinding  **Mod + Shift + U**
Includes:
* User identifier
* Weather inforamation
* Audio Player
* Control Sliders
* Calendar
* TODO List

![](https://github.com/bytes-chaser/dotfiles/blob/main/assets/neon-2.0/user.png)

### Statistics bar
Statistics bar can be opened on left screen side by selecting it on Left Bar Switch or with keybinding  **Mod + Shift + S**
Currentry available two versions og the bar that can be selected on **cfg/init.lua  widgets_version.stat_bar** 
#### V1
Includes:
* System State Monitor
* Top Processes Monitor
* Partitions Monitor

![](https://github.com/bytes-chaser/dotfiles/blob/main/assets/neon-2.0/stats.png)

#### V2
Includes:
* Top Processes Monitor
* System State & Partitions Monitor Charts

![](https://github.com/bytes-chaser/dotfiles/blob/main/assets/neon-2.0/stats-v2.png)


### Theme Switch
Scrollable list of available themes.
Each theme option changing style of:
* AwesomeWM itself
* Spotify (spicetify)
* Alacritty
* Cava

![](https://github.com/bytes-chaser/dotfiles/blob/main/assets/neon-2.0/theme_switch.png)

## Available themes
### Coffepot-v1
<img width="100%" align="center" src="https://github.com/bytes-chaser/dotfiles/blob/main/assets/neon-2.0/themes/coffepot-1/showcase.png" />

### Light-Blue-v1
<img width="100%" align="center" src="https://github.com/bytes-chaser/dotfiles/blob/main/assets/neon-2.0/themes/light-blue-1/showcase.png" />

### Neon-Dream-v1
<img width="100%" align="center" src="https://github.com/bytes-chaser/dotfiles/blob/main/assets/neon-2.0/themes/neon-1/showcase.png" />

### Neon-Dream-v2
<img width="100%" align="center" src="https://github.com/bytes-chaser/dotfiles/blob/main/assets/neon-2.0/themes/neon-2/showcase.png" />

### Nord-v1
<img width="100%" align="center" src="https://github.com/bytes-chaser/dotfiles/blob/main/assets/neon-2.0/themes/nord-1/showcase.png" />

## :sparkling_heart: Tkanks for your attention

You can leave any ideas, notes on the "issues" tab and support me by dropping some coins.

[![](https://img.shields.io/badge/sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#EA4AAA)](https://github.com/sponsors/bytes-chaser)
