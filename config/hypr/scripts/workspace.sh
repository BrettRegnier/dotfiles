#!/bin/bash 
# Usage: workspace.sh <relative_workspace_num>

RELATIVE_WORKSPACE=$1
WORKSPACES_PER_MONITOR=3

MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .id')

WORKSPACE=$(( MONITOR * WORKSPACES_PER_MONITOR * RELATIVE_WORKSPACE))

hyprctl dispatch "hl.dsp.focus({ workspace=\"$WORKSPACE\" })"
