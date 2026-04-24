local wezterm = require 'wezterm'

return {
  default_prog = { '/bin/zsh' },

  -- Font
  font = wezterm.font('JetBrains Mono'),
  font_size = 12,

  -- Colors
  color_scheme = 'Hacktober',
  colors = {
    selection_fg = '#1a1a1a',
    selection_bg = '#b0854b',
  },

  -- Window
  window_background_opacity = 0.95,
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

    { key = 'LeftArrow',  mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Left'  },
    { key = 'RightArrow', mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Right' },
    { key = 'UpArrow',    mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Up'    },
    { key = 'DownArrow',  mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Down'  },

    -- -----------------------------------------------------------------------
    -- WezTerm — clipboard
    -- -----------------------------------------------------------------------

    -- Override default: only copy when a terminal selection exists.
    -- Required for kbprompt-zsh compatibility: the default CTRL+SHIFT+C writes
    -- an empty string to the clipboard when no terminal selection exists, wiping
    -- the text that kbprompt just synced — breaking the next paste.
    { key = 'C', mods = 'CTRL|SHIFT', action = wezterm.action_callback(function(window, pane)
      local sel = window:get_selection_text_for_pane(pane)
      if sel ~= '' then
        window:copy_to_clipboard(sel, 'Clipboard')
      end
    end) },

    -- -----------------------------------------------------------------------
    -- kbprompt-zsh — escape sequences forwarded to zsh
    -- See kbprompt/profiles/linux-wezterm.md for the full picture.
    -- -----------------------------------------------------------------------

    -- Ctrl+Left/Right: WezTerm reserves these — send explicit sequences so
    -- zsh receives them reliably for word jump.
    { key = 'LeftArrow',  mods = 'CTRL', action = wezterm.action.SendString '\x1b[1;5D' },
    { key = 'RightArrow', mods = 'CTRL', action = wezterm.action.SendString '\x1b[1;5C' },

    -- Ctrl+Shift+Left/Right: WezTerm reserves these for pane navigation —
    -- override to forward to zsh for kbprompt word selection instead.
    { key = 'LeftArrow',  mods = 'CTRL|SHIFT', action = wezterm.action.SendString '\x1b[1;6D' },
    { key = 'RightArrow', mods = 'CTRL|SHIFT', action = wezterm.action.SendString '\x1b[1;6C' },

    -- Ctrl+Shift+Up/Down: disable WezTerm defaults (scroll) so these keys
    -- don't interfere when pressed accidentally near the selection combos.
    { key = 'UpArrow',   mods = 'CTRL|SHIFT', action = wezterm.action.DisableDefaultAssignment },
    { key = 'DownArrow', mods = 'CTRL|SHIFT', action = wezterm.action.DisableDefaultAssignment },
  },
}
