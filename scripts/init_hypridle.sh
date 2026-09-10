#!/bin/bash 

sudo systemctl disable display-manager

# Update the greetd config.toml
sudo rm /etc/greetd/config.toml
sudo cp ../etc/greetd/config.toml /etc/greetd/config.toml
sudo systemctl enable greetd
