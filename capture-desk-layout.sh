#!/bin/bash

# Documentation:
# @raycast.schemaVersion 1
# @raycast.title Capture Desk Display Layout
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🖥️
# @raycast.packageName Displays

# Captures the current display arrangement + main display into
# ~/.hammerspoon/desk-layout.json (via Hammerspoon's URL handler).
# Run this whenever you've arranged your desk displays the way you want them.

open -g "hammerspoon://capturelayout"
