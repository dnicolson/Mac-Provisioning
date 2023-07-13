#!/usr/bin/env bash

read -p "ℹ️  Grant Terminal Full Disk Access in System Preferences > Security & Privacy > Privacy..."

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

# Homebrew
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Log in to the App Store
open -a "App Store"
read -p "ℹ️  Log in to the App Store and press any key..."

# Install Casks that require a password
brew install --cask macfuse docker vmware-fusion paragon-ntfs qlvideo xquartz adoptopenjdk8 zoom

# Install Brews, Casks and MAS apps
brew install mas
brew bundle

# Remove quarantine
xattr -r -d com.apple.quarantine /Applications 2> /dev/null
xattr -r -d com.apple.quarantine ~/Library/QuickLook

# Wait for Dropbox
read -p "ℹ️  Setup Dropbox and press any key..."

# Symlink application settings from Dropbox
mackup restore

# Setup version manager
source $OPT_PATH/asdf/libexec/asdf.sh

# Install Ruby
asdf plugin-add ruby
RUBY_VERSION=`asdf list-all ruby | grep -v [a-z] | tail -1`
asdf install ruby $RUBY_VERSION
asdf global ruby $RUBY_VERSION

# Install Node
asdf plugin-add nodejs
NODE_VERSION=`asdf list-all nodejs | grep -v [a-z] | tail -1`
asdf install nodejs lts-fermium # 14
asdf install nodejs lts-gallium # 16
asdf install nodejs $NODE_VERSION
asdf global nodejs $NODE_VERSION

# Install Python
asdf plugin-add python
PYTHON2_VERSION=`asdf list-all python | grep -v [a-z] | grep '^2' | tail -1`
PYTHON3_VERSION=`asdf list-all python | grep -v [a-z] | grep '^3' | tail -1`
asdf install python $PYTHON2_VERSION
asdf install python $PYTHON3_VERSION
asdf global python $PYTHON3_VERSION $PYTHON2_VERSION

# Install gems and packages
gem install bundler dotenv pry sass scss_lint
npm i -g serverless vsce kill-port
pip install pylint pyatv cfn-sphere pyunpack patool

# fish shell
echo $BIN_PATH/fish | sudo tee -a /etc/shells
chsh -s $BIN_PATH/fish
fish -c fisher

# Restart QuickLook
qlmanage -r

# Show ~/Library folder
setfile -a v ~/Library
chflags nohidden ~/Library

# Customise Dock
dockutil --no-restart --remove all
dockutil --no-restart --add "/System/Applications/System Preferences.app"
dockutil --no-restart --add "/System/Applications/Music.app"
dockutil --no-restart --add "/System/Applications/Photos.app"
dockutil --no-restart --add "/Applications/Mimestream.app"
dockutil --no-restart --add "/System/Applications/Messages.app"
dockutil --no-restart --add "/Applications/Messenger.app"
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
dockutil --no-restart --add "/Applications/Streaks.app"
dockutil --no-restart --add "/Applications/Grammatisch.app"

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

echo -e "\033[1mFinal Steps\033[0m"

cat << EOF
macOS
- Log in to iCloud
- Set resolution to 'More Space' in System Preferences > Displays
- Uncheck 'Show date' in System Preferences > Dock & Menu Bar > Clock
- Change appearance to dark
- Authorize Music

Chrome
- Sign in
- Add 'https://www.dropbox.com/s/raw/<id>/AdblockPlusFilterList.txt' to the 'Adblock Plus' filter list
- Setup Tampermonkey Dropbox sync

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

Accounts
- Add Feedly and Instapaper accounts to Reeder
- Sign in to Mimestream with Google
- Sign in to TickTick with Google
- Sign in to Slack
- Sign in to Mate Translate
EOF
