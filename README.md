# Morris's Dotfiles

Bootstrap script for setting up a fresh Manjaro i3 install with my configs.

## Quick Start

```bash
git clone https://github.com/morris2spears/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x bootstrap.sh
./bootstrap.sh
```

## What it does

1. Installs `yay` (AUR helper)
2. Installs non-default packages (neovim, fish, steam, vesktop, etc.)
3. Clones individual config repos to their correct paths:
   - [i3-config](https://github.com/morris2spears/i3-config) → `~/.config/i3/`
   - [polybar-config](https://github.com/morris2spears/polybar-config) → `~/.config/polybar/`
   - [picom-config](https://github.com/morris2spears/picom-config) → `~/.config/picom/`
   - [alacritty-config](https://github.com/morris2spears/alacritty-config) → `~/.config/alacritty/`
   - [rofi-config](https://github.com/morris2spears/rofi-config) → `~/.config/rofi/`
   - [fish-config](https://github.com/morris2spears/fish-config) → `~/.config/fish/`
   - [tmux-config](https://github.com/morris2spears/tmux-config) → `~/.config/tmux/`
   - [neovim-dots](https://github.com/morris2spears/neovim-dots) → `~/.config/nvim/`
4. Sets fish as default shell
5. Enables system services (tailscale, sshd, NetworkManager)

## Live Wallpaper

The bootstrap script automatically downloads the [Black Hole in Nebula](https://motionbgs.com/black-hole-in-nebula) 4K live wallpaper from motionbgs.com. It plays via `xwinwrap` + `mpv`.
