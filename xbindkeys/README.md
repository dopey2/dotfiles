# xbindkeys

Binds `Meta+Space` to open KRunner via DBus, bypassing KDE's kglobalaccel.

## Setup

### 1. Install

```sh
sudo apt install xbindkeys # Debian / Ubuntu
```

```sh
sudo zypper install xbindkeys # Open SUSE
```

```sh
sudo pacman -S xbindkeys # Arch
```

```sh
sudo dnf install xbindkeys # Fedora
```

### 2. Create symlinks

```sh
ln -sf ~/repos/dotfiles/xbindkeys/xbindkeysrc ~/.xbindkeysrc
ln -sf ~/repos/dotfiles/xbindkeys/xbindkeys.desktop ~/.config/autostart/xbindkeys.desktop
```
