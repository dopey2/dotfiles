#!/bin/zsh

# ==========================================================================
# ZSH Key Bindings V5 - IDE-like text editing for the terminal
# ==========================================================================
#
# PURPOSE:
#   This script adds IDE/editor-like text selection behavior to the zsh
#   command line. By default, zsh has no visual text selection with
#   keyboard shortcuts. This script fixes that.
#
# HOW IT WORKS:
#   Terminals were designed in the 1970s and don't natively support
#   modern text editing concepts like "Shift+Arrow to select text".
#   The terminal only receives raw bytes (escape sequences), and the
#   shell only sees those bytes -- it has no concept of "Shift" or
#   "Cmd" as modifiers.
#
#   To bridge this gap, we use a two-layer approach:
#
#   Layer 1 - iTerm2 (terminal emulator):
#     iTerm2 intercepts key combos (like Shift+Left) and translates
#     them into unique escape sequences (like \e[1;2D) that it sends
#     to the shell. Without this, the shell would never know Shift
#     was pressed.
#
#   Layer 2 - This script (zsh):
#     This script listens for those escape sequences and performs the
#     corresponding actions (select text, move cursor, etc.) using
#     zsh's line editor (ZLE) API. It also automatically copies
#     selected text to the system clipboard via pbcopy, so Cmd+C
#     keeps working for mouse-selected text and Cmd+V pastes
#     whatever was last selected.
#
#
# ==========================================================================
# REQUIREMENTS
# ==========================================================================
#
# 1. ITERM2 - OPTION KEY CONFIGURATION
#    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#    In iTerm2: Settings > Profiles > Keys > General
#
#    "Option Key Sends" must be set based on your keyboard layout:
#
#    - US/English keyboard: Set to "Esc+" (value 2).
#      This makes Option act as Meta/Alt for terminal apps.
#
#    - European keyboards (French, German, etc.): Set to "Normal" (value 0).
#      European layouts use Option to type essential programming
#      characters (|, \, {, }, ~, @, #, etc). Setting it to Esc+
#      would break those characters. Word jumping is handled by
#      Ctrl+Left/Right instead (configured below).
#
#    "Right Option Key Sends" can be set independently. A common
#    setup for European keyboards is:
#      Left Option  = Normal (for special characters like |, {, })
#      Right Option = Normal (same)
#    Word navigation uses Ctrl+Arrow instead of Opt+Arrow.
#
#
# 2. ITERM2 - PROFILE KEY MAPPINGS
#    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#    In iTerm2: Settings > Profiles > Keys > Key Mappings
#
#    These mappings translate key combos into escape sequences that
#    the shell can understand. Add each entry by clicking "+":
#      - "Keyboard Shortcut": press the key combo
#      - "Action": select "Send Escape Sequence"
#      - "Esc+": type the value from the table below
#
#    For "Send Hex Code" entries, select "Send Hex Code" as the
#    action and type the hex value.
#
#    +---------------------+-----------------------+----------+-------------+
#    | Shortcut            | Action                | Value    | Purpose     |
#    +---------------------+-----------------------+----------+-------------+
#    | Ctrl+Left           | Send Escape Sequence  | b        | Word left   |
#    | Ctrl+Right          | Send Escape Sequence  | f        | Word right  |
#    | Shift+Left          | Send Escape Sequence  | [1;2D    | Select left |
#    | Shift+Right         | Send Escape Sequence  | [1;2C    | Select right|
#    | Ctrl+Shift+Left     | Send Escape Sequence  | [1;6D    | Sel word L  |
#    | Ctrl+Shift+Right    | Send Escape Sequence  | [1;6C    | Sel word R  |
#    | Ctrl+Shift+Home     | Send Escape Sequence  | [1;6H    | Sel to home |
#    | Ctrl+Shift+End      | Send Escape Sequence  | [1;6F    | Sel to end  |
#    | Cmd+A               | Send Escape Sequence  | [97;9u   | Select all  |
#    | Cmd+Z               | Send Escape Sequence  | [122;8u  | Undo        |
#    | Cmd+Shift+Z         | Send Escape Sequence  | [122;9u  | Redo        |
#    +---------------------+-----------------------+----------+-------------+
#    | Cmd+Backspace        | Send Hex Code         | 0x15     | Kill line   |
#    | Opt+Backspace        | Send Hex Code         | 0x1b 0x7f| Kill word   |
#    | Delete Forward       | Send Hex Code         | 0x4      | Del char    |
#    | Opt+Delete Forward   | Send Escape Sequence  | d        | Del word    |
#    +---------------------+-----------------------+----------+-------------+
#
#    ESCAPE SEQUENCE FORMAT:
#    The sequences follow the xterm convention: \e[1;{mod}{key}
#      - mod 2 = Shift
#      - mod 6 = Ctrl+Shift
#      - key D = Left, C = Right, H = Home, F = End
#    The [97;9u format is the Kitty keyboard protocol (97 = 'a').
#
#
# 3. SOURCE ORDER IN .zshrc
#    ~~~~~~~~~~~~~~~~~~~~~~
#    This file MUST be sourced AFTER oh-my-zsh in your .zshrc:
#
#      source $ZSH/oh-my-zsh.sh    # first
#      source ~/.zsh_bindingsV5    # after
#
#    If sourced before oh-my-zsh, the bindings will be overwritten
#    by oh-my-zsh defaults and nothing will work.
#
#
# ==========================================================================
# LINUX COMPATIBILITY
# ==========================================================================
#
#   This script is written for macOS + iTerm2 but can work on Linux
#   with two changes:
#
#   1. CLIPBOARD: Replace "pbcopy" with "xclip -selection clipboard"
#      (X11) or "wl-copy" (Wayland) in the _sync-region-to-clipboard
#      function below.
#
#   2. TERMINAL: iTerm2 is macOS-only. On Linux, use a terminal that
#      supports custom key mappings (Alacritty, Kitty, WezTerm, etc).
#      Some terminals (like Kitty) natively send xterm-style modified
#      key sequences (\e[1;2D, \e[1;6D, etc.) without any manual
#      configuration -- the escape sequences in this script would
#      work out of the box. The Cmd+A binding (\e[97;9u) would need
#      to be remapped to a different shortcut since Linux has no Cmd
#      key (e.g., Ctrl+Shift+A with a matching terminal config).
#
#
# ==========================================================================
# ZSH CONCEPTS USED
# ==========================================================================
#
#   ZLE (Zsh Line Editor):
#     The component that handles everything you type at the prompt.
#     It manages the cursor, the text buffer, and all key bindings.
#
#   Widget:
#     A named function registered with ZLE via "zle -N <name>".
#     Only widgets (not regular functions) can be bound to keys
#     with "bindkey". The flow is:
#       1. function my-widget() { ... }   -- define the function
#       2. zle -N my-widget               -- register as widget
#       3. bindkey '\e[...' my-widget     -- bind a key to it
#
#   ZLE Variables:
#     REGION_ACTIVE  1 = text is selected, 0 = no selection
#     MARK           The start position of the selection (integer)
#     CURSOR         The current cursor position (integer)
#     BUFFER         The full text of the current command line
#     CUTBUFFER      Holds the last killed/copied text
#
#   The "." prefix (e.g. "zle .backward-char"):
#     Calls the ORIGINAL built-in widget. When we override a default
#     widget (like "backward-char") with our own version, using
#     "zle .backward-char" calls the original to avoid infinite
#     recursion. Without the dot, it would call our override again.
#
#   KEYTIMEOUT:
#     Time in centiseconds (hundredths of a second) that zsh waits
#     after receiving an ambiguous key (like \e) to decide if it's a
#     standalone key or the start of a multi-byte escape sequence.
#     Default is 40 (400ms). We lower it to 10 (100ms) so that:
#       - Escape sequences from iTerm2 (sent as a burst in <1ms)
#         are still matched correctly.
#       - Standalone ESC is recognized in 100ms instead of 400ms.
#     This has NO effect on typing latency or screen refresh.
#
#
# ==========================================================================
# SHORTCUT REFERENCE
# ==========================================================================
#
# +--------------------------+---------------------+------------------------+
# | Action                   | Shortcut            | Notes                  |
# +--------------------------+---------------------+------------------------+
# | Select char left         | Shift+Left          |                        |
# | Select char right        | Shift+Right         |                        |
# | Select word left         | Ctrl+Shift+Left     |                        |
# | Select word right        | Ctrl+Shift+Right    |                        |
# | Select to line start     | Ctrl+Shift+Home     |                        |
# | Select to line end       | Ctrl+Shift+End      |                        |
# | Select entire prompt     | Cmd+A               | via iTerm2 esc seq     |
# +--------------------------+---------------------+------------------------+
# | Cancel selection (left)  | Left Arrow          | cursor to left edge    |
# | Cancel selection (right) | Right Arrow         | cursor to right edge   |
# | Cancel selection         | Escape              | cursor stays in place  |
# | Cancel selection         | Ctrl+Left/Right     | then jumps a word      |
# | Cancel selection         | Ctrl+A / Ctrl+E     | then jumps to line end |
# +--------------------------+---------------------+------------------------+
# | Type to replace          | any character       | replaces selection     |
# | Delete selection         | Backspace           |                        |
# | Copy selection           | (automatic)         | synced to clipboard    |
# | Paste                    | Cmd+V               | handled by iTerm2      |
# +--------------------------+---------------------+------------------------+
# | Undo                     | Cmd+Z               | via iTerm2 esc seq     |
# | Redo                     | Cmd+Shift+Z         | via iTerm2 esc seq     |
# +--------------------------+---------------------+------------------------+
#

# ==========================================================================
# KEYTIMEOUT — fast ESC recognition
# ==========================================================================
#
# Lower from default 400ms to 100ms. This makes standalone ESC
# responsive while still giving iTerm2 escape sequences (which
# arrive as a <1ms burst) plenty of time to be matched.
KEYTIMEOUT=10

# --- Helper: sync zsh region to system clipboard ---
function _sync-region-to-clipboard() {
    zle copy-region-as-kill
    print -n "$CUTBUFFER" | pbcopy
}

# ==========================================================================
# ESCAPE KEY — cancel selection / fix dead-prefix bug
# ==========================================================================
#
# PROBLEM (V4):
#   Pressing ESC sends \e (0x1B) to zsh. In the emacs keymap, \e is
#   bound to `undefined-key` by default. `undefined-key` does NOT
#   properly consume the \e byte — it leaves it as a dead prefix in
#   the key buffer. The next keypress gets combined with the stale \e:
#     ESC, wait, Left (\eOD) → zsh sees \e + \eOD → \e consumed, "OD" inserted
#     ESC, wait, b           → zsh sees \eb → backward-word (not what you wanted)
#
# FIX:
#   Bind \e (and the \eO prefix which has the same issue) to a real
#   widget. A proper widget fully consumes the key and resets the
#   buffer. We use a deselect widget: pressing ESC cancels any active
#   selection, matching IDE behavior. When no selection is active,
#   it's a harmless no-op.
#
#   Longer sequences starting with \e (like \e[1;2D for Shift+Left
#   or \eOD for Left arrow) still work because zsh always tries to
#   match the longest binding first. The standalone \e binding only
#   fires after KEYTIMEOUT with no following bytes.

function deactivate-region() {
    REGION_ACTIVE=0
}
zle -N deactivate-region

# --- Selection widgets ---

# Select char backward (Shift+Left)
function select-char-backward() {
    if [[ $REGION_ACTIVE -eq 0 ]]; then
        zle set-mark-command
    fi
    REGION_ACTIVE=1
    zle .backward-char
    _sync-region-to-clipboard
}
zle -N select-char-backward

# Select char forward (Shift+Right)
function select-char-forward() {
    if [[ $REGION_ACTIVE -eq 0 ]]; then
        zle set-mark-command
    fi
    REGION_ACTIVE=1
    zle .forward-char
    _sync-region-to-clipboard
}
zle -N select-char-forward

# Select word backward (Ctrl+Shift+Left)
function select-word-backward() {
    if [[ $REGION_ACTIVE -eq 0 ]]; then
        zle set-mark-command
    fi
    REGION_ACTIVE=1
    zle .backward-word
    _sync-region-to-clipboard
}
zle -N select-word-backward

# Select word forward (Ctrl+Shift+Right)
function select-word-forward() {
    if [[ $REGION_ACTIVE -eq 0 ]]; then
        zle set-mark-command
    fi
    REGION_ACTIVE=1
    zle .forward-word
    _sync-region-to-clipboard
}
zle -N select-word-forward

# Select to beginning of line (Ctrl+Shift+Home)
function select-to-beginning-of-line() {
    if [[ $REGION_ACTIVE -eq 0 ]]; then
        zle set-mark-command
    fi
    REGION_ACTIVE=1
    zle .beginning-of-line
    _sync-region-to-clipboard
}
zle -N select-to-beginning-of-line

# Select to end of line (Ctrl+Shift+End)
function select-to-end-of-line() {
    if [[ $REGION_ACTIVE -eq 0 ]]; then
        zle set-mark-command
    fi
    REGION_ACTIVE=1
    zle .end-of-line
    _sync-region-to-clipboard
}
zle -N select-to-end-of-line

# Select entire current prompt (Cmd+A)
function select-entire-prompt() {
    MARK=0
    CURSOR=${#BUFFER}
    REGION_ACTIVE=1
    _sync-region-to-clipboard
}
zle -N select-entire-prompt

# --- Editor-like behavior: deactivate region on movement ---

# IDE-style: Right arrow jumps to right edge of selection
function deactivate-and-forward-char() {
    if [[ $REGION_ACTIVE -eq 1 ]]; then
        if [[ $CURSOR -gt $MARK ]]; then
            :
        else
            CURSOR=$MARK
        fi
        REGION_ACTIVE=0
    else
        zle .forward-char
    fi
}
zle -N forward-char deactivate-and-forward-char

# IDE-style: Left arrow jumps to left edge of selection
function deactivate-and-backward-char() {
    if [[ $REGION_ACTIVE -eq 1 ]]; then
        if [[ $CURSOR -lt $MARK ]]; then
            :
        else
            CURSOR=$MARK
        fi
        REGION_ACTIVE=0
    else
        zle .backward-char
    fi
}
zle -N backward-char deactivate-and-backward-char

function deactivate-and-forward-word() {
    REGION_ACTIVE=0
    zle .forward-word
}
zle -N forward-word deactivate-and-forward-word

function deactivate-and-backward-word() {
    REGION_ACTIVE=0
    zle .backward-word
}
zle -N backward-word deactivate-and-backward-word

function deactivate-and-beginning-of-line() {
    REGION_ACTIVE=0
    zle .beginning-of-line
}
zle -N beginning-of-line deactivate-and-beginning-of-line

function deactivate-and-end-of-line() {
    REGION_ACTIVE=0
    zle .end-of-line
}
zle -N end-of-line deactivate-and-end-of-line

# --- Editor-like behavior: type to replace selection ---

function custom-self-insert() {
    if [[ $REGION_ACTIVE -eq 1 ]]; then
        zle kill-region
        REGION_ACTIVE=0
    fi
    zle .self-insert
}
zle -N self-insert custom-self-insert

function smart-backspace() {
    if [[ $REGION_ACTIVE -eq 1 ]]; then
        zle kill-region
        REGION_ACTIVE=0
    else
        zle .backward-delete-char
    fi
}
zle -N backward-delete-char smart-backspace

# --- Bindkeys ---

# ESC: cancel selection + fix dead-prefix bug (see comment above)
bindkey '\e' deactivate-region
bindkey '\eO' deactivate-region

# Selection
bindkey '\e[1;2D' select-char-backward         # Shift+Left
bindkey '\e[1;2C' select-char-forward          # Shift+Right
bindkey '\e[1;6D' select-word-backward         # Ctrl+Shift+Left
bindkey '\e[1;6C' select-word-forward          # Ctrl+Shift+Right
bindkey '\e[1;6H' select-to-beginning-of-line  # Ctrl+Shift+Home
bindkey '\e[1;6F' select-to-end-of-line        # Ctrl+Shift+End
bindkey '\e[97;9u' select-entire-prompt        # Cmd+A

# Undo / Redo
bindkey '\e[122;8u' undo                       # Cmd+Z
bindkey '\e[122;9u' redo                       # Cmd+Shift+Z