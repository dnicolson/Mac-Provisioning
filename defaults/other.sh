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

# Hide Smart Lists
read -r -d '' XML <<'EOF'
<dict>
  <key>5fc03fcf9b4251d53f94d30e</key>
  <dict>
    <key>Smart_CALENDAR_PROJECT_ID</key>
    <integer>1</integer>
    <key>Smart_NEXT7DAYS_PROJECT_ID</key>
    <integer>1</integer>
    <key>Smart_TODAY_PROJECT_ID</key>
    <integer>1</integer>
    <key>Smart_TOMORROW_PROJECT_ID</key>
    <integer>1</integer>
  </dict>
</dict>
EOF
plutil -remove smart_project_display_status ~/Library/Group\ Containers/75TY9UT8AY.com.TickTick.task.mac/Library/Preferences/75TY9UT8AY.com.TickTick.task.mac.plist
plutil -insert smart_project_display_status -xml "$XML" ~/Library/Group\ Containers/75TY9UT8AY.com.TickTick.task.mac/Library/Preferences/75TY9UT8AY.com.TickTick.task.mac.plist

# Calendar
defaults write com.apple.iCal "display birthdays calendar" 0
