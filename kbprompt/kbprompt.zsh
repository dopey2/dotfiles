#!/bin/zsh

# ==========================================================================
# kbprompt-zsh — IDE-like text selection for the zsh prompt
# ==========================================================================
#
# Binds escape sequences to ZLE widgets that implement Shift+Arrow selection,
# word selection, clipboard sync, and IDE-style cursor/replace behavior.
#
#
# DEPENDENCIES (must be defined before sourcing this script):
#
#   _kbprompt_clipboard_write <text>
#     Function that writes <text> to the system clipboard.
#     Implemented per platform in the profile file.
#
#   KBPROMPT_SEQ_*
#     Escape sequences for each binding. Empty = binding skipped.
#     Defined per terminal in the profile file.
#
#
# ZSH INTERNALS:
#
#   ZLE variables used throughout:
#     REGION_ACTIVE  1 = selection active, 0 = none
#     MARK           selection anchor position
#     CURSOR         current cursor position
#     BUFFER         full command line text
#     CUTBUFFER      last killed/copied text
#
#   "zle .widget-name" calls the original built-in, bypassing any override.
#
#   KEYTIMEOUT (centiseconds): how long zsh waits after an ambiguous ESC
#   before deciding it's standalone. Lowered to 10 (100ms) — fast enough
#   for responsive ESC, long enough for multi-byte sequences arriving in <1ms.


# ==========================================================================
# KEYTIMEOUT — fast ESC recognition
# ==========================================================================

KEYTIMEOUT=10


# ==========================================================================
# CLIPBOARD
# ==========================================================================
#
# The clipboard write implementation is injected by the profile via
# _kbprompt_clipboard_write(). This keeps the core terminal-agnostic.

function _sync-region-to-clipboard() {
    zle copy-region-as-kill
    _kbprompt_clipboard_write "$CUTBUFFER"
}


# ==========================================================================
# ESCAPE KEY — cancel selection / fix dead-prefix bug
# ==========================================================================
#
# PROBLEM:
#   Pressing ESC sends \e (0x1B) to zsh. In the emacs keymap, \e is
#   bound to `undefined-key` by default. `undefined-key` does NOT
#   properly consume the \e byte — it leaves it as a dead prefix in
#   the key buffer. The next keypress gets combined with the stale \e:
#     ESC, wait, Left (\eOD) → zsh sees \e + \eOD → \e consumed, "OD" inserted
#     ESC, wait, b           → zsh sees \eb → backward-word (not what you wanted)
#
# FIX:
#   Bind \e (and the \eO prefix) to a real widget that fully consumes
#   the key and resets the buffer. We use deactivate-region: ESC cancels
#   any active selection, matching IDE behavior. No-op when no selection.
#
#   Longer sequences starting with \e (like \e[1;2D for Shift+Left)
#   still work because zsh always tries to match the longest binding first.

function deactivate-region() {
    REGION_ACTIVE=0
}
zle -N deactivate-region

bindkey '\e'  deactivate-region
bindkey '\eO' deactivate-region


# ==========================================================================
# SELECTION WIDGETS
# ==========================================================================

function select-char-backward() {
    if [[ $REGION_ACTIVE -eq 0 ]]; then zle set-mark-command; fi
    REGION_ACTIVE=1
    zle .backward-char
    _sync-region-to-clipboard
}
zle -N select-char-backward

function select-char-forward() {
    if [[ $REGION_ACTIVE -eq 0 ]]; then zle set-mark-command; fi
    REGION_ACTIVE=1
    zle .forward-char
    _sync-region-to-clipboard
}
zle -N select-char-forward

function select-word-backward() {
    if [[ $REGION_ACTIVE -eq 0 ]]; then zle set-mark-command; fi
    REGION_ACTIVE=1
    zle .backward-word
    _sync-region-to-clipboard
}
zle -N select-word-backward

function select-word-forward() {
    if [[ $REGION_ACTIVE -eq 0 ]]; then zle set-mark-command; fi
    REGION_ACTIVE=1
    zle .forward-word
    _sync-region-to-clipboard
}
zle -N select-word-forward

function select-to-beginning-of-line() {
    if [[ $REGION_ACTIVE -eq 0 ]]; then zle set-mark-command; fi
    REGION_ACTIVE=1
    zle .beginning-of-line
    _sync-region-to-clipboard
}
zle -N select-to-beginning-of-line

function select-to-end-of-line() {
    if [[ $REGION_ACTIVE -eq 0 ]]; then zle set-mark-command; fi
    REGION_ACTIVE=1
    zle .end-of-line
    _sync-region-to-clipboard
}
zle -N select-to-end-of-line

function select-entire-prompt() {
    MARK=0
    CURSOR=${#BUFFER}
    REGION_ACTIVE=1
    _sync-region-to-clipboard
}
zle -N select-entire-prompt


# ==========================================================================
# DEACTIVATE ON MOVEMENT — IDE-style cursor collapse
# ==========================================================================

function deactivate-and-forward-char() {
    if [[ $REGION_ACTIVE -eq 1 ]]; then
        [[ $CURSOR -le $MARK ]] && CURSOR=$MARK
        REGION_ACTIVE=0
    else
        zle .forward-char
    fi
}
zle -N forward-char deactivate-and-forward-char

function deactivate-and-backward-char() {
    if [[ $REGION_ACTIVE -eq 1 ]]; then
        [[ $CURSOR -ge $MARK ]] && CURSOR=$MARK
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


# ==========================================================================
# TYPE TO REPLACE / DELETE SELECTION
# ==========================================================================

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


# ==========================================================================
# BINDKEYS — driven by profile variables
# ==========================================================================

[[ -n "$KBPROMPT_SEQ_CTRL_LEFT"        ]] && bindkey "$KBPROMPT_SEQ_CTRL_LEFT"        backward-word
[[ -n "$KBPROMPT_SEQ_CTRL_RIGHT"       ]] && bindkey "$KBPROMPT_SEQ_CTRL_RIGHT"       forward-word
[[ -n "$KBPROMPT_SEQ_SHIFT_LEFT"       ]] && bindkey "$KBPROMPT_SEQ_SHIFT_LEFT"       select-char-backward
[[ -n "$KBPROMPT_SEQ_SHIFT_RIGHT"      ]] && bindkey "$KBPROMPT_SEQ_SHIFT_RIGHT"      select-char-forward
[[ -n "$KBPROMPT_SEQ_CTRL_SHIFT_LEFT"  ]] && bindkey "$KBPROMPT_SEQ_CTRL_SHIFT_LEFT"  select-word-backward
[[ -n "$KBPROMPT_SEQ_CTRL_SHIFT_RIGHT" ]] && bindkey "$KBPROMPT_SEQ_CTRL_SHIFT_RIGHT" select-word-forward
[[ -n "$KBPROMPT_SEQ_SHIFT_HOME"       ]] && bindkey "$KBPROMPT_SEQ_SHIFT_HOME"       select-to-beginning-of-line
[[ -n "$KBPROMPT_SEQ_SHIFT_END"        ]] && bindkey "$KBPROMPT_SEQ_SHIFT_END"        select-to-end-of-line
[[ -n "$KBPROMPT_SEQ_CTRL_SHIFT_HOME"  ]] && bindkey "$KBPROMPT_SEQ_CTRL_SHIFT_HOME"  select-to-beginning-of-line
[[ -n "$KBPROMPT_SEQ_CTRL_SHIFT_END"   ]] && bindkey "$KBPROMPT_SEQ_CTRL_SHIFT_END"   select-to-end-of-line
[[ -n "$KBPROMPT_SEQ_SELECT_ALL"       ]] && bindkey "$KBPROMPT_SEQ_SELECT_ALL"       select-entire-prompt
[[ -n "$KBPROMPT_SEQ_UNDO"             ]] && bindkey "$KBPROMPT_SEQ_UNDO"             undo
[[ -n "$KBPROMPT_SEQ_REDO"             ]] && bindkey "$KBPROMPT_SEQ_REDO"             redo
