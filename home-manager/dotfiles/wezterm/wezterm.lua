-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

config.front_end = "WebGpu"

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- config.color_scheme = 'AdventureTime'

config.font = wezterm.font 'FiraCode Nerd Font Mono'

-- config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.hide_mouse_cursor_when_typing = false

-- Background
config.window_background_opacity = 0.8

-- Title bar
config.window_decorations = "NONE"

config.unix_domains = {
  {
    name = "unix",
  },
}

config.ssh_domains = {
  {
    name = 'datacs',
    remote_address = 'data.cs.purdue.edu',
    username = 'pate1464',
  },
}

-- This causes `wezterm` to act as though it was started as
-- `wezterm connect unix` by default, connecting to the unix
-- domain on startup.
-- If you prefer to connect manually, leave out this line.
-- config.default_gui_startup_args = { "connect", "unix" }

-- and finally, return the configuration to wezterm
return config

