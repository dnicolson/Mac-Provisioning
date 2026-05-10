#!/usr/bin/env bash

PLIST="$HOME/Library/Preferences/com.apple.finder.plist"
APP="/Applications/OpenInTerminal-Lite.app"
ICON="OpenInTerminal-Lite.png"

# Set new Finder windows to Home
defaults write com.apple.finder NewWindowTarget -string "PfHm"

# Set list view as the default for all Finder windows
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Set new app icon
npx -y fileicon set $APP $ICON

# Add the app to the Finder toolbar
curl -o /tmp/add-to-finder-toolbar.sh https://gist.githubusercontent.com/dnicolson/de1b8a7d0ee1bb31b09eb7f8afd38a65/raw/b86d7612806746c2968a63d713ff292d69959dc8/add-to-finder-toolbar.sh
chmod +x /tmp/add-to-finder-toolbar.sh
/tmp/add-to-finder-toolbar.sh "$APP" -1
