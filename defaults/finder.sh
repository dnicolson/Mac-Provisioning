#!/usr/bin/env bash

PLIST="$HOME/Library/Preferences/com.apple.finder.plist"
APP="/Applications/OpenInTerminal-Lite.app"
ICON="OpenInTerminal-Lite.png"

# Set new Finder windows to Home
defaults write com.apple.finder NewWindowTarget -string "PfHm"

# Set list view as the default for all Finder windows
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Disable the sound played when emptying the Trash
defaults write com.apple.finder FinderSounds -bool false

# Make desktop icons snap to grid
/usr/libexec/PlistBuddy -c "Add :DesktopViewSettings dict" "$PLIST" >/dev/null 2>&1 || true
/usr/libexec/PlistBuddy -c "Add :DesktopViewSettings:IconViewSettings dict" "$PLIST" >/dev/null 2>&1 || true
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" "$PLIST" >/dev/null 2>&1 \
  || /usr/libexec/PlistBuddy -c "Add :DesktopViewSettings:IconViewSettings:arrangeBy string grid" "$PLIST"

# Set new app icon
npx -y fileicon set $APP $ICON

# Add the app to the Finder toolbar
curl -o /tmp/add-to-finder-toolbar.sh https://gist.githubusercontent.com/dnicolson/de1b8a7d0ee1bb31b09eb7f8afd38a65/raw/b86d7612806746c2968a63d713ff292d69959dc8/add-to-finder-toolbar.sh
chmod +x /tmp/add-to-finder-toolbar.sh
/tmp/add-to-finder-toolbar.sh "$APP" -1

# Disable "Drag windows to menu bar to fill screen"
defaults write com.apple.WindowManager EnableTopTilingByEdgeDrag -bool false

# Disable "Drag windows to top of screen to enter Mission Control"
defaults write com.apple.dock enterMissionControlByTopWindowDrag -bool false
killall Dock
