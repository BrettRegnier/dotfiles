#!/usr/bin/env bash

set -euo pipefail

STATE_FILE="$HOME/.local/state/theme"
GHOSTTY_THEME_FILE="$HOME/.config/ghostty/theme-selector.conf"

DARK_GHOSTTY_THEME="base16-ashes"
LIGHT_GHOSTTY_THEME="Catppuccin Latte"

DARK_G_COLOR_SCHEME="prefer-dark"
LIGHT_G_COLOR_SCHEME="prefer-light"

DARK_GTK_THEME="Adwaita-dark"
LIGHT_GTK_THEME="Adwaita"

DARK_ICON_THEME="Papirus-Dark"
LIGHT_ICON_THEME="Papirus-Light"

mkdir -p "$(dirname "$STATE_FILE")" "$(dirname "$GHOSTTY_THEME_FILE")"

CURRENT="dark"
if [[ -f "$STATE_FILE" ]]; then
  CURRENT="$(cat "$STATE_FILE")"
fi

if [[ "$CURRENT" == "dark" ]]; then
  NEW_MODE="light"
  GHOSTTY_THEME="$LIGHT_GHOSTTY_THEME"
  G_COLOR_SCHEME="$LIGHT_G_COLOR_SCHEME"
  GTK_THEME="$LIGHT_GTK_THEME"
  ICON_THEME="$LIGHT_ICON_THEME"
else
  NEW_MODE="dark"
  GHOSTTY_THEME="$DARK_GHOSTTY_THEME"
  G_COLOR_SCHEME="$DARK_G_COLOR_SCHEME"
  GTK_THEME="$DARK_GTK_THEME"
  ICON_THEME="$DARK_ICON_THEME"
fi

echo "$NEW_MODE" > "$STATE_FILE"
echo "theme = $GHOSTTY_THEME" > "$GHOSTTY_THEME_FILE"

# Reload ghostty
pkill -SIGUSR2 -x ghostty 2>/dev/null || true

# Tell neovim to reload theme
SOCKET_DIR="$HOME/.cache/nvim/sockets"

if [ -d "$SOCKET_DIR" ] && [ "$(ls -A "$SOCKET_DIR" 2>/dev/null)" ]; then
  for socket in "$SOCKET_DIR"/nvim_*.pipe; do
    if [ -e "$socket" ]; then
      # Sends the command in parallel to all instances instantly
      nvim --server "$socket" --remote-send "<Cmd>doautocmd User GlobalNotify<CR>" &>/dev/null &
    fi
  done
  wait
  echo "Notification broadcasted to all Neovim instances."
else
  echo "No active Neovim instances found."
fi

gsettings set org.gnome.desktop.interface color-scheme "'$G_COLOR_SCHEME'"
gsettings set org.gnome.desktop.interface gtk-theme "'$GTK_THEME'"
gsettings set org.gnome.desktop.interface icon-theme "'$ICON_THEME'"

command -v notify-send >/dev/null 2>&1 && notify-send "Theme" "Switched to $NEW_MODE" -t 1500

exit 0
