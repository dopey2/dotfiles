#!/bin/zsh
# OpenSUSE Tumbleweed machine setup
# Run manually, section by section — not a blind one-shot installer

# ── NVIDIA Driver (RTX 4070 / G06, Secure Boot) ─────────────────────────────
# Run section by section — check each step before proceeding

# 1. Snapshot before touching drivers
sudo snapper create --type single --description "pre-nvidia-driver" --cleanup-algorithm number

# 2. Ensure the correct NVIDIA repo package is installed (Tumbleweed, not MicroOS)
#    Check what's installed:
rpm -qa | grep -i nvidia | grep repos
#    If openSUSE-repos-MicroOS-NVIDIA is present, swap it:
sudo zypper install openSUSE-repos-Tumbleweed-NVIDIA
#    Remove any manually added NVIDIA repo to avoid duplicates:
zypper lr | grep -i nvidia        # find the repo name
# sudo zypper removerepo <name>   # run with actual name from above

# 3. Install driver (signed — no MOK enrollment needed with Tumbleweed shim)
#    Do NOT use nvidia-drivers-G06 directly: pulls libcrypto.so.1.1 (OpenSSL 1.1, unavailable)
sudo zypper install nvidia-open-driver-G06-signed-kmp-default nvidia-drivers-insync-latest

# 4. Reboot — driver loads automatically, no MOK screen expected
# sudo reboot

# Verify after reboot:
# nvidia-smi
# glxinfo | grep -E 'renderer string|vendor string' | grep -v GLX


# ── JetBrains IDEs (WebStorm, CLion, etc.) ─────────────────────────────────
# GTK libs required — JBR bundled JRE looks for them in /usr/lib, OpenSUSE puts them in /usr/lib64
sudo zypper install gtk3-devel libgtk-3-0