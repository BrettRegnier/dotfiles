#!/bin/bash 

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


#### nvim ####
rm -rf ~/.config/nvim 
ln -s "$DOTFILES/nvim" ~/.config/nvim

#### ghostty ####
rm -rf ~/.config/ghostty
ln -s "$DOTFILES/ghostty" ~/.config/ghostty

#### alacritty ####
rm -rf ~/.config/alacritty
ln -s "$DOTFILES/alacritty" ~/.config/alacritty

#### tmux ####
rm -rf ~/.config/tmux
ln -s "$DOTFILES/tmux" ~/.config/tmux

#### hypr ####
rm -rf ~/.config/hypr
ln -s "$DOTFILES/hypr" ~/.config/hypr

#### waybar ####
rm -rf ~/.config/waybar
ln -s "$DOTFILES/waybar" ~/.config/waybar
