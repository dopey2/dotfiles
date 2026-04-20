# Profile — Linux + WezTerm

---

## Dependencies

### xclip

The clipboard write function uses `xclip` to write to the X11 clipboard. Install it before sourcing the profile:

```sh
sudo zypper install xclip
```

---

## WezTerm configuration

Most escape sequences are sent automatically by WezTerm (xterm standard). Two entries require explicit `SendString`
bindings because WezTerm reserves those combos for pane navigation by default.

Add these to the `keys` table in `wezterm/linux/wezterm.lua`:

```lua
{ key = 'LeftArrow',  mods = 'CTRL|SHIFT', action = wezterm.action.SendString '\x1b[1;6D' },
{ key = 'RightArrow', mods = 'CTRL|SHIFT', action = wezterm.action.SendString '\x1b[1;6C' },
```

### CTRL+SHIFT+C clipboard wipe bug

WezTerm's default `CTRL+SHIFT+C` binding runs `CopyTo='Clipboard'`. When no terminal mouse selection exists, it writes
an empty string to the clipboard — wiping whatever was there. This breaks `CTRL+SHIFT+V` paste immediately after.

Fix already applied in `wezterm/linux/wezterm.lua`: the binding is overridden to only copy when a selection actually
exists:

```lua
{ key = 'C', mods = 'CTRL|SHIFT', action = wezterm.action_callback(function(window, pane)
  local sel = window:get_selection_text_for_pane(pane)
  if sel ~= '' then
    window:copy_to_clipboard(sel, 'Clipboard')
  end
end) },
```

---

## Escape sequences

| Variable                        | Sequence  | Key              | Action               |
|---------------------------------|-----------|------------------|----------------------|
| `KBPROMPT_SEQ_CTRL_LEFT`        | `\e[1;5D` | Ctrl+Left        | Word left            |
| `KBPROMPT_SEQ_CTRL_RIGHT`       | `\e[1;5C` | Ctrl+Right       | Word right           |
| `KBPROMPT_SEQ_SHIFT_LEFT`       | `\e[1;2D` | Shift+Left       | Select char left     |
| `KBPROMPT_SEQ_SHIFT_RIGHT`      | `\e[1;2C` | Shift+Right      | Select char right    |
| `KBPROMPT_SEQ_CTRL_SHIFT_LEFT`  | `\e[1;6D` | Ctrl+Shift+Left  | Select word left     |
| `KBPROMPT_SEQ_CTRL_SHIFT_RIGHT` | `\e[1;6C` | Ctrl+Shift+Right | Select word right    |
| `KBPROMPT_SEQ_SHIFT_HOME`       | `\e[1;2H` | Shift+Home       | Select to line start |
| `KBPROMPT_SEQ_SHIFT_END`        | `\e[1;2F` | Shift+End        | Select to line end   |
| `KBPROMPT_SEQ_CTRL_SHIFT_HOME`  | `\e[1;6H` | Ctrl+Shift+Home  | Select to line start |
| `KBPROMPT_SEQ_CTRL_SHIFT_END`   | `\e[1;6F` | Ctrl+Shift+End   | Select to line end   |
| `KBPROMPT_SEQ_SELECT_ALL`       | `\x01`    | Ctrl+A           | Select entire prompt |
| `KBPROMPT_SEQ_UNDO`             | *(unset)* | —                | Not set up yet       |
| `KBPROMPT_SEQ_REDO`             | *(unset)* | —                | Not set up yet       |
