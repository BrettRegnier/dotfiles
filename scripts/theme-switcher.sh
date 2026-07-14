#!/usr/bin/env bash

set -euo pipefail

STATE_FILE="$HOME/.local/state/theme"
GHOSTTY_THEME_FILE="$HOME/.config/ghostty/theme-selector.conf"

DARK_GHOSTTY_THEME="catppuccin-mocha"
LIGHT_GHOSTTY_THEME="catppuccin-latte"

mkdir -p "$(dirname "$STATE_FILE")" "$(dirname "$GHOSTTY_THEME_FILE")"

CURRENT="dark"
if [[ -f "$STATE_FILE" ]]; then
  CURRENT="$(cat "$STATE_FILE")"
fi

if [[ "$CURRENT" == "dark" ]]; then
  NEW_MODE="light"
  GHOSTTY_THEME="$LIGHT_GHOSTTY_THEME"
else
  NEW_MODE="dark"
  GHOSTTY_THEME="$DARK_GHOSTTY_THEME"
fi

echo "$NEW_MODE" > "$STATE_FILE"
echo "theme = $GHOSTTY_THEME" > "$GHOSTTY_THEME_FILE"

# Reload ghostty
pkill -SIGUSR2 -x ghostty 2>/dev/null || true

command -v notify-send >/dev/null 2>&1 && notify-send "Theme" "Switched to $NEW_MODE" -t 1500

exit 0
