#!/usr/bin/env bash

# Alfred
open -a "Alfred 4"
read -p "Enter Alfred Powerpack..."
# Allow ~/Dropbox/Apps path for Alfred preferences
defaults write com.runningwithcrayons.Alfred-Preferences dropbox.allowappsfolder -bool TRUE
defaults write com.runningwithcrayons.Alfred-Preferences syncfolder -string "~/Dropbox/Apps"

# Chrome
open -a "Google Chrome"
read -p "Setup Chrome and close application..."
./defaults/other/chrome.sh

# TickTick
open -a "TickTick"
read -p "Setup TickTick and close application..."
plutil -replace TKQuickAddTaskHotkeyIdentifier -json '{}' ~/Library/Group\ Containers/75TY9UT8AY.com.TickTick.task.mac/Library/Preferences/75TY9UT8AY.com.TickTick.task.mac.plist

# Calendar
open -a "Calendar"
read -p "Setup Calendar and close application..."
IFS=$'\n'
for CALENDAR in $(find ~/Library/Calendars -name "Info.plist")
do
  if plutil -extract Title xml1 -o - $CALENDAR | grep Birthdays > /dev/null; then
    plutil -replace AlarmsDisabled -bool true $CALENDAR
  fi
done
killall CalendarAgent
rm ~/Library/Calendars/Calendar\ Cache*
