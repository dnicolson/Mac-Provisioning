#!/usr/bin/env bash

read -p "ℹ️  Grant Terminal Full Disk Access in System Preferences > Security & Privacy > Privacy..."

if [[ $(uname -m) == 'arm64' ]]; then
  BIN_PATH=/opt/homebrew/bin
  OPT_PATH=/opt/homebrew/opt
else
  BIN_PATH=/usr/local/bin
  OPT_PATH=/usr/local/opt
fi

# SSH key
ssh-keygen -t rsa
echo "ℹ️  Please add this public key to GitHub: https://github.com/account/ssh"
cat ~/.ssh/id_rsa.pub
echo

# Xcode
xcode-select --install

# Homebrew
if test ! $(which brew); then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Log in to the App Store
open -a "App Store"
read -p "ℹ️  Log in to the App Store and press any key..."

# Install Brews, Casks and MAS apps
$BIN_PATH/brew install --cask macfuse docker vmware-fusion paragon-ntfs qlvideo xquartz adoptopenjdk8
$BIN_PATH/brew bundle

# Remove quarantine
xattr -r -d com.apple.quarantine /Applications 2> /dev/null
xattr -r -d com.apple.quarantine ~/Library/QuickLook

# Wait for Dropbox
read -p "ℹ️  Setup Dropbox and press any key..."

# Symlink application settings from Dropbox
mackup restore

# Setup version manager
source $OPT_PATH/asdf/asdf.sh

# Install Ruby
$BIN_PATH/asdf plugin-add ruby
RUBY_VERSION=`$BIN_PATH/asdf list-all ruby | grep -v [a-z] | tail -1`
$BIN_PATH/asdf install ruby $RUBY_VERSION
$BIN_PATH/asdf global ruby $RUBY_VERSION

# Install Node
$BIN_PATH/asdf plugin-add nodejs
NODE10_VERSION=`$BIN_PATH/asdf list-all nodejs | grep -v [a-z] | grep '^10' | tail -1`
NODE12_VERSION=`$BIN_PATH/asdf list-all nodejs | grep -v [a-z] | grep '^12' | tail -1`
NODE_VERSION=`$BIN_PATH/asdf list-all nodejs | grep -v [a-z] | tail -1`
$BIN_PATH/asdf install nodejs $NODE10_VERSION
$BIN_PATH/asdf install nodejs $NODE12_VERSION
$BIN_PATH/asdf install nodejs $NODE_VERSION
$BIN_PATH/asdf global nodejs $NODE_VERSION

# Install Python
$BIN_PATH/asdf plugin-add python
PYTHON2_VERSION=`$BIN_PATH/asdf list-all python | grep -v [a-z] | grep '^2' | tail -1`
PYTHON3_VERSION=`$BIN_PATH/asdf list-all python | grep -v [a-z] | grep '^3' | tail -1`
$BIN_PATH/asdf install python $PYTHON2_VERSION
$BIN_PATH/asdf install python $PYTHON3_VERSION
$BIN_PATH/asdf global python $PYTHON3_VERSION $PYTHON2_VERSION

# Install gems and packages
#gem install bundler dotenv pry sass scss_lint
#npm i -g prettier sass-lint eslint eslint-config-standard eslint-plugin-import eslint-plugin-node eslint-plugin-promise eslint-plugin-standard eslint-config-prettier eslint-plugin-prettier kill-port
#pip install pylint pyatv cfn-sphere pyunpack patool

# fish shell
echo $BIN_PATH/fish | sudo tee -a /etc/shells
chsh -s $BIN_PATH/fish
$BIN_PATH/fish -c fisher

# Restart QuickLook
qlmanage -r

# Show ~/Library folder
setfile -a v ~/Library
chflags nohidden ~/Library

# Customise Dock
$BIN_PATH/dockutil --no-restart --remove all
$BIN_PATH/dockutil --no-restart --add "/System/Applications/System Preferences.app"
$BIN_PATH/dockutil --no-restart --add "/System/Applications/iTunes.app"
$BIN_PATH/dockutil --no-restart --add "/Applications/Mimestream.app"
$BIN_PATH/dockutil --no-restart --add "/Applications/Slack.app"
$BIN_PATH/dockutil --no-restart --add "/System/Applications/Messages.app"
$BIN_PATH/dockutil --no-restart --add "/Applications/Messenger.app"
$BIN_PATH/dockutil --no-restart --add "/System/Applications/Photos.app"
$BIN_PATH/dockutil --no-restart --add "/Applications/ReadKit.app"
$BIN_PATH/dockutil --no-restart --add "/Applications/1Password 7.app"
$BIN_PATH/dockutil --no-restart --add "/Applications/TickTick.app"
$BIN_PATH/dockutil --no-restart --add "/System/Applications/Notes.app"
$BIN_PATH/dockutil --no-restart --add "/Applications/Outbank.app"
$BIN_PATH/dockutil --no-restart --add "/Applications/Google Chrome.app"
$BIN_PATH/dockutil --no-restart --add "/Applications/Google Chrome Canary.app"
$BIN_PATH/dockutil --no-restart --add "/Applications/Safari.app"
$BIN_PATH/dockutil --no-restart --add "/Applications/Gitfox.app"
$BIN_PATH/dockutil --no-restart --add "/Applications/Visual Studio Code.app"
$BIN_PATH/dockutil --no-restart --add "/Applications/Sublime Text.app"
$BIN_PATH/dockutil --no-restart --add "/Applications/RunJS.app"
$BIN_PATH/dockutil --no-restart --add "/Applications/Xcode.app"
$BIN_PATH/dockutil --no-restart --add "/Applications/Hex Fiend.app"
$BIN_PATH/dockutil --no-restart --add "/System/Applications/Utilities/Console.app"
$BIN_PATH/dockutil --no-restart --add "/System/Applications/Utilities/Activity Monitor.app"
$BIN_PATH/dockutil --no-restart --add "/Applications/iTerm.app"
$BIN_PATH/dockutil --no-restart --add "/System/Applications/Home.app"
$BIN_PATH/dockutil --no-restart --add "/System/Applications/Books.app"
$BIN_PATH/dockutil --no-restart --add "/Applications/Streaks.app"

killall Dock

# Defaults
./defaults.sh

# Add Go2Shell to Finder
./defaults/finder.sh

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
