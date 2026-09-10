#!/bin/bash 

# Update the system with all of the tools we want
./scripts/install_pkgs.sh

./scripts/init_config.sh

./scripts/init_hypridle.sh

# TODO tailscale setup
