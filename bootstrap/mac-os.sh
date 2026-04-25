#!/bin/zsh
# Mac OS machine setup
# Run manually, section by section — not a blind one-shot installer


#────────────────────────────────────────────────────────────────
# GUI Apps

# https://wezterm.org/
# ♥ GPU-accelerated terminal emulator, configured via Lua
brew install --cask wezterm

# https://github.com/lwouis/alt-tab-macos
# ♥ Better alt-tab with window previews
brew install --cask alt-tab

# https://github.com/MonitorControl/MonitorControl
# ♥ Control brightness, contrast and volume of external monitors
brew install --cask monitorcontrol


#────────────────────────────────────────────────────────────────
# CLI Tools

# https://github.com/ajeetdsouza/zoxide
# ♥ Smarter cd — jumps to frecent directories
brew install zoxide

# https://github.com/eza-community/eza
# ♥ Better ls with colors and icons
brew install eza

# https://github.com/sharkdp/bat
# Better cat with syntax highlighting
brew install bat

# https://github.com/burntsushi/ripgrep
# Better grep — fast recursive search
brew install ripgrep

# JSON processor
brew install jq

# YAML processor
brew install yq

# ♥ Better ps — process viewer
brew install procs

# https://github.com/junegunn/fzf
# Fuzzy finder
brew install fzf

# https://github.com/aloxaf/fzf-tab
# fzf-powered tab completion for zsh
brew install fzf-tab

# zsh plugins
# sometimes useful, sometimes you just want to break your keyboard against the wall
# suggestions don't always match your intent, disable if annoying
brew install zsh-autosuggestions
brew install zsh-completions

# Android screen mirroring over USB
brew install scrcpy

# Security audit tool.
# Can be useful from time to time, run every few months to check for new issues.
brew install lynis
