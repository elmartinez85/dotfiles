#!/bin/bash
# Force all floating windows on the current workspace to tile

# Get all window IDs on the focused workspace
window_ids=$(aerospace list-windows --workspace focused --format '%{window-id}')

# Iterate through each window and toggle to tiling if it's floating
for wid in $window_ids; do
    # Focus the window
    aerospace focus --window-id "$wid" 2>/dev/null
    # Set it to tiling layout
    aerospace layout tiling 2>/dev/null
done

# Apply tiles layout to organize them in a grid
aerospace layout tiles
