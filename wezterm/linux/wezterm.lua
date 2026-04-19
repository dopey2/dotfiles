local wezterm = require 'wezterm'

return {
  default_prog = { '/bin/zsh' },

  -- Font
  font = wezterm.font('JetBrains Mono'),
  font_size = 12,

  -- Colors
  color_scheme = 'Hacktober',
  -- Window
  window_background_opacity = 0.95,
  window_padding = {
    left = 8,
    right = 8,
    top = 8,
    bottom = 8,
  },

  keys = {
    -- Pane splits
    { key = 'E', mods = 'CTRL|SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = 'O', mods = 'CTRL|SHIFT', action = wezterm.action.SplitVertical   { domain = 'CurrentPaneDomain' } },

    -- Pane navigation
    { key = 'LeftArrow',  mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Left'  },
    { key = 'RightArrow', mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Right' },
    { key = 'UpArrow',    mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Up'    },
    { key = 'DownArrow',  mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Down'  },

    -- Word jump (explicit escape sequences for zsh reliability)
    { key = 'LeftArrow',  mods = 'CTRL', action = wezterm.action.SendString '\x1b[1;5D' },
    { key = 'RightArrow', mods = 'CTRL', action = wezterm.action.SendString '\x1b[1;5C' },
  },
}
