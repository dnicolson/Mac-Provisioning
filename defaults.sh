#!/usr/bin/env bash

# Use scroll gesture with the Ctrl (^) modifier key to zoom
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144

# Disable the “are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Disable swipe navigation in Chrome
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false

# Always show scrollbars
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# New window location
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://$(cd ~; pwd)/"

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Show item info below icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Script Editor
defaults write com.apple.ScriptEditor2 ApplePersistence -bool false
defaults write com.apple.ScriptEditor2 DefaultLanguageType -int 1785946994

# Hide welcome window
defaults write com.apple.dt.Xcode XCShowWelcomeWindow 0

# Music
defaults write com.apple.Music dontAskDownloadArtwork 1
defaults write com.apple.Music dontAskForPlaylistItemRemoval 1
defaults write com.apple.Music dontAskForPlaylistRemoval 1
defaults write com.apple.Music dontWarnWhenEditingMultiple 1
defaults write com.apple.Music automaticallyDownloadArtwork 1

# Hide language menu
defaults write com.apple.TextInputMenu visible -bool false

# Feedback Assistant
defaults write com.apple.appleseed.FeedbackAssistant.plist FBASuppressPrivacyNotice -bool true

# Menu extras
defaults write com.apple.systemuiserver menuExtras -array \
  "/System/Library/CoreServices/Menu Extras/Clock.menu" \
  "/System/Library/CoreServices/Menu Extras/Battery.menu" \
  "/System/Library/CoreServices/Menu Extras/AirPort.menu" \
  "/System/Library/CoreServices/Menu Extras/Bluetooth.menu"
killall SystemUIServer

# Add login items
osascript -e 'tell application "System Events" to make login item at end with properties {name: "Alfred 4", path: "/Applications/Alfred 4.app"}'
osascript -e 'tell application "System Events" to make login item at end with properties {name: "Itsycal", path: "/Applications/Itsycal.app"}'
osascript -e 'tell application "System Events" to make login item at end with properties {name: "MacMediaKeyForwarder", path: "/Applications/MacMediaKeyForwarder.app"}'
osascript -e 'tell application "System Events" to make login item at end with properties {name: "PixelSnap 2", path: "/Applications/PixelSnap 2.app"}'
osascript -e 'tell application "System Events" to make login item at end with properties {name: "Rocket", path: "/Applications/Rocket.app"}'

# Screen Saver
defaults -currentHost write com.apple.screensaver moduleDict -dict moduleName Aerial path ~/Library/Screen\ Savers/Aerial.saver type 0
