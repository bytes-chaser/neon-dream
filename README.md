<h1 align="center">Neon Dream</h1>
<p align="center">
  Awesome Windows Manager setup
</p>
<br>

<img width="50%" align="right" src="https://github.com/bytes-chaser/dotfiles/blob/main/assets/neon-1.0/collage.png" />

## General Information
<table>
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
    <td><b>Equalizer</b></td>
    <td><a href="https://github.com/karlstav/cava" target="_blank">cava</a></td>
  <tr>
</table>


## Additional Information

### zsh
Confugured with [oh-my-zsh](https://ohmyz.sh/) framework. Theme [Agnoster](https://github.com/ohmyzsh/ohmyzsh/wiki/Themes#agnoster) with [custom color sheme](https://github.com/bytes-chaser/dotfiles/tree/main/.config/oh-my-zsh/custom/themes).

### Spotify
Spotify client customized using [spicetify](https://github.com/spicetify/spicetify-cli). Client using [Dreary](https://github.com/spicetify/spicetify-themes/blob/master/THEMES.md#dreary) theme with a [custom color scheme](https://github.com/bytes-chaser/dotfiles/tree/main/.config/spicetify/Themes/Dreary).

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
* [Windowed](https://addons.mozilla.org/en-US/firefox/addon/windowed/Youtobe) plugin used to for in-window fullscreen mode 

## Awesome
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

### Widgets

#### Decorations
By default decorations are hidden. To toggle active client decorations visibility use **Mod + T** key binding. It will not affect other opened clients and  new clients. **Mod  + Ctrl + T** key binding will toggle decoration visibility for all opened and new spawned clients 
Decorations buttons has 5 buttons. Each of them has icon that becoming visible on hover. For last 4 buttons icon can changing depending on client state.
Buttons:
1. Close
2. Maximize/Unmaximize
3. Toggle floating mode
4. Toggle sticky
5. Toggle ontop


![](https://github.com/bytes-chaser/dotfiles/blob/main/assets/neon-1.0/decorations.png)

#### Bar (wibox)
Transparent bar with rounded widget subsections.
![](https://github.com/bytes-chaser/dotfiles/blob/main/assets/neon-1.0/bar.png)

##### Tag Switch
![](https://github.com/bytes-chaser/dotfiles/blob/main/assets/neon-1.0/tags.png)

##### Active Client Title

![](https://github.com/bytes-chaser/dotfiles/blob/main/assets/neon-1.0/active_client_title.png)
##### Bar player
Minimal version of dashboard player

![](https://github.com/bytes-chaser/dotfiles/blob/main/assets/neon-1.0/active_client_title.png)

##### CPU graph
![](https://github.com/bytes-chaser/dotfiles/blob/main/assets/neon-1.0/cpu_graph.png)

##### RAM graph
![](https://github.com/bytes-chaser/dotfiles/blob/main/assets/neon-1.0/ram_graph.png)

##### Systray
Includes aweomewm default time and layout widgets. Has additional battery widget

![](https://github.com/bytes-chaser/dotfiles/blob/main/assets/neon-1.0/systray.png)

###### Battery
Shows battery charge level on hover. Icon is changing depends on battery charge level.
On click opening shutdown window

![](https://github.com/bytes-chaser/dotfiles/blob/main/assets/neon-1.0/battery.png)

###### Shutdown Window
Simple controls for shutdown or restarting the system.

![](https://github.com/bytes-chaser/dotfiles/blob/main/assets/neon-1.0/shutdown.png)

#### Dashboard
To show/hide dahsboard use **Mod + Ctrl + S** keys binding
![](https://github.com/bytes-chaser/dotfiles/blob/main/assets/neon-1.0/dashboard.png)

Dasboard includes:
##### Profile
Widgets loading active user name and profile image from **~/profile.png**

![](https://github.com/bytes-chaser/dotfiles/blob/main/assets/neon-1.0/profile.png)
##### Player
Loading current active playing metadata (title, artist, album, image), has simple controls. Tested so far with a spotify and youtube.
![](https://github.com/bytes-chaser/dotfiles/blob/main/assets/neon-1.0/player.png)
##### Sliders
Simple controls for system volume and brightness change.
![](https://github.com/bytes-chaser/dotfiles/blob/main/assets/neon-1.0/sliders.png)
##### System Monitor
Progreess bars representing current system status including:
* Memory usage
* CPU load
* Battery charge level
* Temprature

![](https://github.com/bytes-chaser/dotfiles/blob/main/assets/neon-1.0/sys-stat.png)

##### Disks Monitor:
Progreess bars representing system mounted disks usage

![](https://github.com/bytes-chaser/dotfiles/blob/main/assets/neon-1.0/disk-stat.png)
