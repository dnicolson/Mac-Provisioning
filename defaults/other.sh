#!/usr/bin/env bash

# Alfred
open -a "Alfred 4"
read -p "ℹ️  Enter Alfred Powerpack..."
defaults write com.runningwithcrayons.Alfred-Preferences dropbox.allowappsfolder -bool TRUE
open -a "Alfred Preferences"
read -p "ℹ️  Set \"~/Dropbox/Apps\" as the sync folder..."
# defaults write com.runningwithcrayons.Alfred-Preferences syncfolder -string "~/Dropbox/Apps"

# Chrome
open -a "Google Chrome"
read -p "ℹ️  Setup Chrome and close application..."
./defaults/other/chrome.sh

# TickTick
open -a "TickTick"
read -p "ℹ️  Setup TickTick and close application..."

# Remove the Shift-Command-A hot key
defaults write com.TickTick.task.mac TKQuickAddTaskHotkeyIdentifier -data ""

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
open -a "Calendar"
read -p "ℹ️  Setup Calendar and close application..."
IFS=$'\n'
for CALENDAR in $(find ~/Library/Calendars -name "Info.plist")
do
  if plutil -extract Title xml1 -o - $CALENDAR | grep Birthdays > /dev/null; then
    plutil -replace AlarmsDisabled -bool true $CALENDAR
  fi
done
killall CalendarAgent
rm ~/Library/Calendars/Calendar\ Cache*
