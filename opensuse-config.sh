#!/bin/zsh
# OpenSUSE Tumbleweed machine setup
# Run manually, section by section — not a blind one-shot installer

# ── JetBrains IDEs (WebStorm, CLion, etc.) ─────────────────────────────────
# GTK libs required — JBR bundled JRE looks for them in /usr/lib, OpenSUSE puts them in /usr/lib64
sudo zypper install gtk3-devel libgtk-3-0
