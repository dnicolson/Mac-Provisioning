#!/usr/bin/env bash

# Chrome
open -a "Google Chrome"
read -p "ℹ️  Set up Chrome and close application..."
./defaults/other/chrome.sh

# TickTick
open -a "TickTick"
read -p "ℹ️  Set up TickTick and close application..."

# Remove the Shift-Command-A hot key
defaults write com.TickTick.task.mac TKQuickAddTaskHotkeyIdentifier -data ""

# Remove the Shift-Command-O hot key
defaults write com.TickTick.task.mac TKShowOrHideAppHotkeyIdentifier -data ""

# Calendar
defaults write com.apple.iCal "display birthdays calendar" 0
