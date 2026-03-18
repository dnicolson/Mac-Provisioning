#!/usr/bin/env bash

read -p "ℹ️  Grant Terminal Full Disk Access in System Settings > Privacy & Security > Full Disk Access"

if [[ $(uname -m) == 'arm64' ]]; then
  softwareupdate --install-rosetta --agree-to-license
  PREFIX=/opt/homebrew
else
  PREFIX=/usr/local
fi
PATH=$PREFIX/bin:$PATH
BIN_PATH=$PREFIX/bin
OPT_PATH=$PREFIX/opt

# SSH key
ssh-keygen -t rsa
echo "ℹ️  Please add this public key to GitHub: https://github.com/account/ssh"
cat ~/.ssh/id_rsa.pub
echo

# Xcode
xcode-select --install
sudo xcodebuild -license accept

# Homebrew
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Log in to the App Store
open -a "App Store"
read -p "ℹ️  Log in to the App Store and press any key..."

# Install Casks that require a password
brew install --cask macfuse zoom

# Install Brews, Casks and MAS apps
brew install mas
brew bundle

# Remove quarantine
xattr -r -d com.apple.quarantine /Applications 2> /dev/null
xattr -r -d com.apple.quarantine ~/Library/QuickLook

# Wait for Dropbox
read -p "ℹ️  Set up Dropbox and press any key..."

# Symlink application settings from Dropbox
mackup restore

mise install

# fish shell
echo $BIN_PATH/fish | sudo tee -a /etc/shells
chsh -s $BIN_PATH/fish

# Restart QuickLook
qlmanage -r

# Show ~/Library folder
setfile -a v ~/Library
chflags nohidden ~/Library

# Customise Dock
dockutil --no-restart --remove all
dockutil --no-restart --add "/System/Applications/System Settings.app"
dockutil --no-restart --add "/System/Applications/Music.app"
dockutil --no-restart --add "/System/Applications/Photos.app"
dockutil --no-restart --add "/Applications/Mimestream.app"
dockutil --no-restart --add "/System/Applications/Messages.app"
dockutil --no-restart --add "/Applications/Reeder.app"
dockutil --no-restart --add "/Applications/Bitwarden.app"
dockutil --no-restart --add "/Applications/TickTick.app"
dockutil --no-restart --add "/System/Applications/Notes.app"
dockutil --no-restart --add "/Applications/MoneyMoney.app"
dockutil --no-restart --add "/Applications/Slack.app"
dockutil --no-restart --add "/Applications/Google Chrome.app"
dockutil --no-restart --add "/Applications/Safari.app"
dockutil --no-restart --add "/Applications/Tower.app"
dockutil --no-restart --add "/Applications/DevUtils.app"
dockutil --no-restart --add "/Applications/Sublime Text.app"
dockutil --no-restart --add "/Applications/Visual Studio Code.app"
dockutil --no-restart --add "/Applications/RunJS.app"
dockutil --no-restart --add "/Applications/Xcode.app"
dockutil --no-restart --add "/Applications/Hex Fiend.app"
dockutil --no-restart --add "/Applications/iTerm.app"
dockutil --no-restart --add "/System/Applications/Utilities/Console.app"
dockutil --no-restart --add "/System/Applications/Utilities/Activity Monitor.app"
dockutil --no-restart --add "/System/Applications/Home.app"
dockutil --no-restart --add "/Applications/ChatGPT.app"
dockutil --no-restart --add "/Applications/Streaks.app"
dockutil --no-restart --add "/Applications/Grammatisch.app"

killall Dock

# Defaults
./defaults.sh

# Add OpenInTerminal-Lite.app to Finder (broken)
# ./defaults/finder.sh

# Set Dropbox defaults
./defaults/dropbox.sh

# Other defaults
./defaults/other.sh

# Set default file handlers
duti handlers.duti

# Create locate database
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist

# Set default DNS
networksetup -setdnsservers Wi-Fi 1.1.1.1 1.0.0.1 2606:4700:4700::1111 2606:4700:4700::1001

echo -e "\033[1mFinal Steps\033[0m"

cat << EOF
macOS
- Set resolution to "More Space" in System Settings > Displays
- Disable "Automatically adjust brightness" in System Settings > Displays
- Disable "Force Click and haptic feedback" in System Settings > Trackpad
- Disable "Drag windows to mene bar to fill screen in System Settings > Desktop & Dock
- Enable "Use scroll gesture with modifier keys to zoom" in System Settings > Accessibility > Zoom

App Store iOS apps
- kino.de
- Proton Authenticator
- Provenance
- put.io
- SwitchBot

Chrome
- Set up Tampermonkey Dropbox sync

AppCleaner
- Turn on SmartDelete

Visual Studio Code
- Turn on Settings Sync

Sublime Text
- Install Package Control

Itsycal
- Launch

Raycast
- Open and sign in with GitHub
- Import Open in Code extension

TopNotch
- Open and enable

Tower
- Activate license

PixelSnap
- Enter license
- Change global hotkey to Shift-Command-6

MoneyMoney
- Copy database

iTerm
- General > Set shell to login shell
- General > Reuse previous session's directory
- Terminal > Disable show mark indicators

OpenInTerminal-Lite
- Open and set up
- Add to toolbar in Finder

DevUtils
- Activate license

SwiftBar
- Set plugin path to Dropbox/Apps/SwiftBar

Accounts
- Add Feedly and Instapaper accounts to Reeder
- Sign in to Mimestream with Google
- Sign in to Mate Translate
- Sign in to Bitwarden
EOF
