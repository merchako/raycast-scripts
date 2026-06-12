#!/bin/bash

# Documentation:
# @raycast.schemaVersion 1
# @raycast.title Restore Desk Display Layout
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🖥️
# @raycast.packageName Displays

# Manually re-applies the saved desk display layout (arrangement + main display).
# The Hammerspoon watcher does this automatically; this is a manual fallback.

open -g "hammerspoon://restorelayout"
