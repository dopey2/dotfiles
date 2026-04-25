#!/bin/zsh

# ==========================================================================
# kbprompt profile — macOS
# ==========================================================================
#
# ITERM2 SETUP REQUIRED:
#   Settings > Profiles > Keys > Key Mappings — add each entry below.
#   Action: "Send Escape Sequence", value is the part after \e.
#
#   +---------------------+-----------------------+----------+
#   | Shortcut            | Action                | Value    |
#   +---------------------+-----------------------+----------+
#   | Shift+Left          | Send Escape Sequence  | [1;2D    |
#   | Shift+Right         | Send Escape Sequence  | [1;2C    |
#   | Ctrl+Shift+Left     | Send Escape Sequence  | [1;6D    |
#   | Ctrl+Shift+Right    | Send Escape Sequence  | [1;6C    |
#   | Ctrl+Shift+Home     | Send Escape Sequence  | [1;6H    |
#   | Ctrl+Shift+End      | Send Escape Sequence  | [1;6F    |
#   | Cmd+A               | Send Escape Sequence  | [97;9u   |
#   | Cmd+Z               | Send Escape Sequence  | [122;8u  |
#   | Cmd+Shift+Z         | Send Escape Sequence  | [122;9u  |
#   +---------------------+-----------------------+----------+

# Writes selected text to the macOS clipboard via pbcopy.
function _kbprompt_clipboard_write() {
    printf '%s' "$1" | pbcopy
}

KBPROMPT_SEQ_CTRL_LEFT=$'\eb'              # Ctrl+Left       — word left
KBPROMPT_SEQ_CTRL_RIGHT=$'\ef'             # Ctrl+Right      — word right

KBPROMPT_SEQ_SHIFT_LEFT=$'\e[1;2D'        # Shift+Left      — select char left
KBPROMPT_SEQ_SHIFT_RIGHT=$'\e[1;2C'       # Shift+Right     — select char right
KBPROMPT_SEQ_CTRL_SHIFT_LEFT=$'\e[1;6D'   # Ctrl+Shift+Left  — select word left
KBPROMPT_SEQ_CTRL_SHIFT_RIGHT=$'\e[1;6C'  # Ctrl+Shift+Right — select word right
KBPROMPT_SEQ_SHIFT_HOME=$'\e[1;2H'        # Shift+Home      — select to line start
KBPROMPT_SEQ_SHIFT_END=$'\e[1;2F'         # Shift+End       — select to line end
KBPROMPT_SEQ_CTRL_SHIFT_HOME=$'\e[1;6H'   # Ctrl+Shift+Home — select to line start
KBPROMPT_SEQ_CTRL_SHIFT_END=$'\e[1;6F'    # Ctrl+Shift+End  — select to line end
KBPROMPT_SEQ_SELECT_ALL=$'\e[97;9u'       # Cmd+A           — select entire prompt (Kitty keyboard protocol)
KBPROMPT_SEQ_UNDO=$'\e[122;8u'            # Cmd+Z           — undo
KBPROMPT_SEQ_REDO=$'\e[122;9u'            # Cmd+Shift+Z     — redo
