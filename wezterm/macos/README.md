
## Setup

```sh
ln -sf ~/repos/dotfiles/wezterm/macos/wezterm.lua ~/.wezterm.lua
```

or

```sh
ln -s ~/repos/dotfiles/wezterm/macos/wezterm.lua ~/.config/wezterm/wezterm.lua
```

---

## Key bindings

| Key               | Action                                      |
|-------------------|---------------------------------------------|
| CTRL + SHIFT + E  | Split panel vertical (one left one right)   |
| CTRL + SHIFT + O  | Split panel horizontal (one top one bottom) |
| OPT + ARROW       | Panel navigation                            |
| CTRL + LEFT/RIGHT | Jump to words                               |
| HOME/END          | Jump to begin/end of the line               |

---

## Key bindings + kbprompt-zsh

| Key                       | Action                              |
|---------------------------|-------------------------------------|
| SHIFT + LEFT/RIGHT        | Select character left/right         |
| CTRL + SHIFT + LEFT/RIGHT | Select word left/right              |
| SHIFT + HOME/END          | Select to line start/end            |
| CMD + A                   | Select entire prompt                |
| CMD + Z                   | Undo                                |
| CMD + SHIFT + Z           | Redo                                |
| ESC                       | Deselect                            |
| Type while selected       | Replace selection                   |
| Backspace while selected  | Delete selection                    |
| LEFT/RIGHT while selected | Collapse selection to cursor        |
