#!/bin/zsh

# ==========================================================================
# kbprompt profile — Linux
# ==========================================================================
#
# WEZTERM SETUP:
#   The escape sequences below are sent by WezTerm via SendString bindings
#   in wezterm.lua. Shift+Left/Right are sent by WezTerm by default (xterm
#   standard). Ctrl+Shift+Left/Right require explicit SendString entries
#   since WezTerm uses those for pane navigation by default.
#   See dotfiles/wezterm/linux/wezterm.lua.

# Writes selected text to the X11 clipboard via xclip.
# Requires: xclip (sudo zypper install xclip)
function _kbprompt_clipboard_write() {
    print -n "$1" | xclip -selection clipboard
}

KBPROMPT_SEQ_CTRL_LEFT=$'\e[1;5D'         # Ctrl+Left       — word left
KBPROMPT_SEQ_CTRL_RIGHT=$'\e[1;5C'        # Ctrl+Right      — word right

KBPROMPT_SEQ_SHIFT_LEFT=$'\e[1;2D'        # Shift+Left      — select char left
KBPROMPT_SEQ_SHIFT_RIGHT=$'\e[1;2C'       # Shift+Right     — select char right
KBPROMPT_SEQ_CTRL_SHIFT_LEFT=$'\e[1;6D'   # Ctrl+Shift+Left  — select word left
KBPROMPT_SEQ_CTRL_SHIFT_RIGHT=$'\e[1;6C'  # Ctrl+Shift+Right — select word right
KBPROMPT_SEQ_SHIFT_HOME=$'\e[1;2H'        # Shift+Home      — select to line start
KBPROMPT_SEQ_SHIFT_END=$'\e[1;2F'         # Shift+End       — select to line end
KBPROMPT_SEQ_CTRL_SHIFT_HOME=$'\e[1;6H'   # Ctrl+Shift+Home — select to line start
KBPROMPT_SEQ_CTRL_SHIFT_END=$'\e[1;6F'    # Ctrl+Shift+End  — select to line end
KBPROMPT_SEQ_SELECT_ALL=$'\x01'           # Ctrl+A          — select entire prompt (overrides default beginning-of-line)
KBPROMPT_SEQ_UNDO=''                      # TODO, not setup yet
KBPROMPT_SEQ_REDO=''                      # TODO, not setup yet
