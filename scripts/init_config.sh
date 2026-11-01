#!/bin/bash 

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES=$(dirname "$DOTFILES")

for dir in "$DOTFILES/config"/*/; do
    config=$(basename "$dir")
    rm -rf ~/.config/"$config"
    ln -s "$dir" ~/.config/"$config"
done
