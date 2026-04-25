# Profile — macOS

---

## iTerm2 configuration

iTerm2 must be configured to send escape sequences for each key combo.

Go to: **Settings > Profiles > Keys > Key Mappings** — add each entry below.
For each row: click `+`, set Action to `Send Escape Sequence`, and enter the value from the table.

| Shortcut         | Action               | Value     |
|------------------|----------------------|-----------|
| Shift+Left       | Send Escape Sequence | `[1;2D`   |
| Shift+Right      | Send Escape Sequence | `[1;2C`   |
| Ctrl+Shift+Left  | Send Escape Sequence | `[1;6D`   |
| Ctrl+Shift+Right | Send Escape Sequence | `[1;6C`   |
| Ctrl+Shift+Home  | Send Escape Sequence | `[1;6H`   |
| Ctrl+Shift+End   | Send Escape Sequence | `[1;6F`   |
| Cmd+A            | Send Escape Sequence | `[97;9u`  |
| Cmd+Z            | Send Escape Sequence | `[122;8u` |
| Cmd+Shift+Z      | Send Escape Sequence | `[122;9u` |

> The `[97;9u` and `[122;8u` format is the Kitty keyboard protocol. iTerm2 supports sending it via
`Send Escape Sequence`.

---

## Escape sequences

| Variable                        | Sequence    | Key              | Action               |
|---------------------------------|-------------|------------------|----------------------|
| `KBPROMPT_SEQ_CTRL_LEFT`        | `\eb`       | Ctrl+Left        | Word left            |
| `KBPROMPT_SEQ_CTRL_RIGHT`       | `\ef`       | Ctrl+Right       | Word right           |
| `KBPROMPT_SEQ_SHIFT_LEFT`       | `\e[1;2D`   | Shift+Left       | Select char left     |
| `KBPROMPT_SEQ_SHIFT_RIGHT`      | `\e[1;2C`   | Shift+Right      | Select char right    |
| `KBPROMPT_SEQ_CTRL_SHIFT_LEFT`  | `\e[1;6D`   | Ctrl+Shift+Left  | Select word left     |
| `KBPROMPT_SEQ_CTRL_SHIFT_RIGHT` | `\e[1;6C`   | Ctrl+Shift+Right | Select word right    |
| `KBPROMPT_SEQ_SHIFT_HOME`       | `\e[1;2H`   | Shift+Home       | Select to line start |
| `KBPROMPT_SEQ_SHIFT_END`        | `\e[1;2F`   | Shift+End        | Select to line end   |
| `KBPROMPT_SEQ_CTRL_SHIFT_HOME`  | `\e[1;6H`   | Ctrl+Shift+Home  | Select to line start |
| `KBPROMPT_SEQ_CTRL_SHIFT_END`   | `\e[1;6F`   | Ctrl+Shift+End   | Select to line end   |
| `KBPROMPT_SEQ_SELECT_ALL`       | `\e[97;9u`  | Cmd+A            | Select entire prompt |
| `KBPROMPT_SEQ_UNDO`             | `\e[122;8u` | Cmd+Z            | Undo                 |
| `KBPROMPT_SEQ_REDO`             | `\e[122;9u` | Cmd+Shift+Z      | Redo                 |
