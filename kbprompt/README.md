# kbprompt-zsh

IDE-like text selection for the zsh prompt. Adds Shift+Arrow selection, word selection, select-all, and clipboard sync — the editing behavior you expect from a code editor, inside your terminal.

---

## How it works

Two layers:

1. **Terminal** — intercepts key combos and translates them into escape sequences sent to the shell. Configured per terminal in `profiles/`.
2. **kbprompt.zsh** — binds those sequences to ZLE widgets that perform selection, cursor movement, and clipboard sync.

All platform-specific values (clipboard command, escape sequences) live in a **profile file**. The core script is terminal-agnostic.

---

## Setup

Source a profile then the core script in `.zshrc`, after oh-my-zsh if used:

```sh
source ~/repos/dotfiles/kbprompt/profiles/linux-wezterm.zsh
source ~/repos/dotfiles/kbprompt/kbprompt.zsh
```

---

## Profiles

| Profile                      | Platform        | Notes                          |
|------------------------------|-----------------|--------------------------------|
| `profiles/linux-wezterm.zsh` | Linux + WezTerm | See `profiles/linux-wezterm.md` |
| `profiles/macos-iterm2.zsh`  | macOS + iTerm2  | See `profiles/macos-iterm2.md`  |

Each profile defines:
- `_kbprompt_clipboard_write()` — writes its first argument to the system clipboard
- `KBPROMPT_SEQ_*` — escape sequences for each binding (empty = binding skipped)

---

## Adding a new profile

1. Copy an existing profile as a starting point
2. Implement `_kbprompt_clipboard_write()` for your OS/clipboard tool
3. Set `KBPROMPT_SEQ_*` to the escape sequences your terminal sends for each key
4. Configure your terminal to send those sequences
5. Source the new profile before `kbprompt.zsh` in `.zshrc`