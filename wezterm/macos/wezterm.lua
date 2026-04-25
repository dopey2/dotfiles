local wezterm = require 'wezterm'

return {
  default_prog = { '/bin/zsh', '--login' },

  -- Font
  font = wezterm.font('JetBrains Mono'),
  font_size = 14,

  -- Colors
  color_scheme = 'Hacktober',
  colors = {
    selection_fg = '#1a1a1a',
    selection_bg = '#b0854b',
  },

  -- Window
  window_background_opacity = 0.9,
  window_padding = {
    left = 8,
    right = 8,
    top = 8,
    bottom = 8,
  },

  keys = {

    -- -----------------------------------------------------------------------
    -- WezTerm — pane management
    -- -----------------------------------------------------------------------

    { key = 'E', mods = 'CTRL|SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = 'O', mods = 'CTRL|SHIFT', action = wezterm.action.SplitVertical   { domain = 'CurrentPaneDomain' } },

    { key = 'LeftArrow',  mods = 'OPT', action = wezterm.action.ActivatePaneDirection 'Left'  },
    { key = 'RightArrow', mods = 'OPT', action = wezterm.action.ActivatePaneDirection 'Right' },
    { key = 'UpArrow',    mods = 'OPT', action = wezterm.action.ActivatePaneDirection 'Up'    },
    { key = 'DownArrow',  mods = 'OPT', action = wezterm.action.ActivatePaneDirection 'Down'  },

    -- Override default: only copy when a terminal selection exists.
    -- Required for kbprompt-zsh compatibility: the default CMD+C writes
    -- an empty string to the clipboard when no terminal selection exists, wiping
    -- the text that kbprompt just synced — breaking the next paste.
    { key = 'c', mods = 'CMD', action = wezterm.action_callback(function(window, pane)
      local sel = window:get_selection_text_for_pane(pane)
      if sel ~= '' then
        window:copy_to_clipboard(sel, 'Clipboard')
      end
    end) },

    -- -----------------------------------------------------------------------
    -- kbprompt-zsh — escape sequences forwarded to zsh
    -- See kbprompt/profiles/macos.zsh for the full picture.
    -- -----------------------------------------------------------------------

    -- Ctrl+Shift+Left/Right: WezTerm reserves these — override to forward to
    -- zsh for kbprompt word selection.
    { key = 'LeftArrow',  mods = 'CTRL|SHIFT', action = wezterm.action.SendString '\x1b[1;6D' },
    { key = 'RightArrow', mods = 'CTRL|SHIFT', action = wezterm.action.SendString '\x1b[1;6C' },

    -- Ctrl+Shift+Up/Down: disable WezTerm defaults (scroll) so these keys
    -- don't interfere when pressed accidentally near the selection combos.
    { key = 'UpArrow',   mods = 'CTRL|SHIFT', action = wezterm.action.DisableDefaultAssignment },
    { key = 'DownArrow', mods = 'CTRL|SHIFT', action = wezterm.action.DisableDefaultAssignment },

    -- Cmd+A/Z/Shift+Z: send Kitty keyboard protocol sequences so kbprompt
    -- receives them. Cmd+C/V are handled natively by macOS — no override needed.
    { key = 'a', mods = 'CMD',       action = wezterm.action.SendString '\x1b[97;9u'  },
    { key = 'z', mods = 'CMD',       action = wezterm.action.SendString '\x1b[122;8u' },
    { key = 'z', mods = 'CMD|SHIFT', action = wezterm.action.SendString '\x1b[122;9u' },
  },
}
