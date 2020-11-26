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
plutil -replace TKQuickAddTaskHotkeyIdentifier -json '{}' ~/Library/Group\ Containers/75TY9UT8AY.com.TickTick.task.mac/Library/Preferences/75TY9UT8AY.com.TickTick.task.mac.plist

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
