#!/usr/bin/env bash
set -euo pipefail

# Morris's Manjaro i3 Bootstrap Script
# Run this on a fresh Manjaro i3 install to get the full setup.
# Usage: curl the repo, then: chmod +x bootstrap.sh && ./bootstrap.sh

GITHUB_USER="morris2spears"
NVIM_GITHUB_USER="morris2spears"

echo "=== Morris's Dotfiles Bootstrap ==="
echo ""

# ─── 1. Install yay (AUR helper) if not present ───
if ! command -v yay &>/dev/null; then
    echo "[*] Installing yay..."
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
    cd /tmp/yay-bin && makepkg -si --noconfirm
    cd -
fi

# ─── 2. Install pacman packages not default on Manjaro i3 ───
echo "[*] Installing pacman packages..."
PACMAN_PKGS=(
    # shell
    fish
    tmux

    # editor
    neovim
    neovide

    # browser
    google-chrome

    # terminal
    alacritty

    # desktop
    picom
    rofi
    polybar
    maim
    xdotool
    feh

    # fonts
    ttf-cascadia-code-nerd
    ttf-firacode-nerd
    noto-fonts-emoji

    # gaming
    steam

    # apps
    discord
    telegram-desktop
    vlc
    nautilus
    pavucontrol

    # tools
    ripgrep
    eza
    github-cli
    tailscale
    openssh
    mpv

    # display
    picom
    arandr
    brightnessctl
)

sudo pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}"

# ─── 3. Install AUR packages ───
echo "[*] Installing AUR packages..."
AUR_PKGS=(
    vesktop
    xwinwrap-git
    i3lock-color
    google-chrome
)

for pkg in "${AUR_PKGS[@]}"; do
    if ! pacman -Q "$pkg" &>/dev/null; then
        yay -S --noconfirm "$pkg"
    fi
done

# ─── 4. Clone config repos ───
echo "[*] Cloning config repos..."

clone_config() {
    local repo="$1"
    local dest="$2"

    if [ -d "$dest/.git" ]; then
        echo "  [skip] $dest already exists, pulling latest..."
        git -C "$dest" pull --ff-only || true
    else
        # Back up existing config if present
        if [ -d "$dest" ] || [ -f "$dest" ]; then
            echo "  [backup] Moving existing $dest to ${dest}.bak"
            mv "$dest" "${dest}.bak"
        fi
        mkdir -p "$(dirname "$dest")"
        git clone "https://github.com/${GITHUB_USER}/${repo}.git" "$dest"
    fi
}

clone_config "i3-config"        "$HOME/.config/i3"
clone_config "polybar-config"   "$HOME/.config/polybar"
clone_config "picom-config"     "$HOME/.config/picom"
clone_config "alacritty-config" "$HOME/.config/alacritty"
clone_config "rofi-config"      "$HOME/.config/rofi"
clone_config "fish-config"      "$HOME/.config/fish"
clone_config "scripts"          "$HOME/scripts"

# Neovim config (separate GitHub account)
if [ -d "$HOME/.config/nvim/.git" ]; then
    echo "  [skip] nvim config already exists, pulling latest..."
    git -C "$HOME/.config/nvim" pull --ff-only || true
else
    if [ -d "$HOME/.config/nvim" ]; then
        mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak"
    fi
    git clone "https://github.com/${NVIM_GITHUB_USER}/neovim-dots.git" "$HOME/.config/nvim"
fi

# ─── 5. Download live wallpaper ───
echo "[*] Setting up live wallpaper..."
mkdir -p "$HOME/Wallpapers"
WALLPAPER="$HOME/Wallpapers/black-hole-in-nebula-2.mp4"
if [ ! -f "$WALLPAPER" ]; then
    echo "  [*] Downloading black hole nebula wallpaper (4K, ~22MB)..."
    curl -L -o "$WALLPAPER" "https://motionbgs.com/dl/4k/3261/"
    echo "  [done] Wallpaper saved to $WALLPAPER"
else
    echo "  [skip] Wallpaper already exists"
fi

# ─── 6. Make scripts executable ───
echo "[*] Setting script permissions..."
chmod +x "$HOME/scripts/"*.sh 2>/dev/null || true
chmod +x "$HOME/.config/polybar/"*.sh 2>/dev/null || true

# ─── 7. Set fish as default shell ───
if [ "$SHELL" != "$(which fish)" ]; then
    echo "[*] Setting fish as default shell..."
    chsh -s "$(which fish)"
fi

# ─── 8. Enable services ───
echo "[*] Enabling services..."
sudo systemctl enable --now tailscaled 2>/dev/null || true
sudo systemctl enable --now NetworkManager 2>/dev/null || true
sudo systemctl enable --now sshd 2>/dev/null || true

echo ""
echo "=== Done! ==="
echo "Log out and back in (or restart i3 with Alt+Shift+r) to apply."
echo ""
echo "Manual steps remaining:"
echo "  - Log in to GitHub: gh auth login"
echo "  - Set up Tailscale: sudo tailscale up"
