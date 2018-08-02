# Use scroll gesture with the Ctrl (^) modifier key to zoom
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool TRUE
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144

# Disable the “are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool FALSE

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Kill iTunes Helper
osascript -e 'tell application "System Events" to delete login item "iTunesHelper"'

# Add login items
osascript -e 'tell application "System Events" to make login item at end with properties {name: "AppTrap", path: (system attribute "HOME") & "/Library/PreferencePanes/AppTrap.prefPane/Contents/Resources/AppTrap.app"}'
osascript -e 'tell application "System Events" to make login item at end with properties {name: "Alfred 3", path: "/Applications/Alfred 3.app"}'
osascript -e 'tell application "System Events" to make login item at end with properties {name: "Itsycal", path: "/Applications/Itsycal.app"}'
osascript -e 'tell application "System Events" to make login item at end with properties {name: "HighSierraMediaKeyEnabler", path: "/Applications/HighSierraMediaKeyEnabler.app"}'
osascript -e 'tell application "System Events" to make login item at end with properties {name: "Rocket", path: "/Applications/Rocket.app"}'
osascript -e 'tell application "System Events" to make login item at end with properties {name: "PixelSnap", path: "/Applications/PixelSnap.app"}'
