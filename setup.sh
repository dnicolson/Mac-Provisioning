#!/usr/bin/env bash

# SSH key
ssh-keygen -t rsa
echo "Please add this public key to GitHub"
echo "https://github.com/account/ssh"

# Xcode
xcode-select --install

# Homebrew
if test ! $(which brew); then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Install Brews, Casks and MAS apps
brew cask install osxfuse
brew bundle
brew cask install docker paragon-ntfs virtualbox qlvideo xquartz

# Wait for Dropbox
read -p "Setup Dropbox and press any key..."

# Symlink application settings from Dropbox
mackup restore

# Setup version manager
source /usr/local/opt/asdf/asdf.sh

# Install Ruby
asdf plugin-add ruby
RUBY_VERSION=`asdf list-all ruby install -l | grep -v - | tail -1`
asdf install ruby $RUBY_VERSION
asdf global ruby $RUBY_VERSION

# Install Node
asdf plugin-add nodejs
bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
NODE_VERSION=`asdf list-all nodejs install -l | grep -v - | tail -1`
asdf install nodejs $NODE_VERSION
asdf global nodejs $NODE_VERSION

# Install Python
export LDFLAGS="-L/usr/local/opt/zlib/lib"
export CPPFLAGS="-I/usr/local/opt/zlib/include"
export PKG_CONFIG_PATH="/usr/local/opt/zlib/lib/pkgconfig"
export KEEP_BUILD_PATH=true
asdf plugin-add python
PYTHON2_VERSION=`asdf list-all python install -l | grep -v - | grep '^2' | tail -1`
PYTHON3_VERSION=`asdf list-all python install -l | grep -v - | grep '^3' | tail -1`
asdf install python $PYTHON2_VERSION
asdf install python $PYTHON3_VERSION
asdf global python $PYTHON3_VERSION $PYTHON2_VERSION
asdf reshim python

# Install gems and packages
gem install bundler dotenv pry sass scss_lint
npm i -g prettier sass-lint eslint eslint-config-standard eslint-plugin-import eslint-plugin-node eslint-plugin-promise eslint-plugin-standard eslint-config-prettier eslint-plugin-prettier
pip install pylint pyatv

# Custom Casks
brew cask install ~/Dropbox/Code/Provisioning/phoneview.rb
brew cask install ~/Dropbox/Code/Provisioning/pixelsnap2.rb
brew cask install ~/Dropbox/Code/Provisioning/airbuddy.rb

# fish shell
echo /usr/local/bin/fish | sudo tee -a /etc/shells
chsh -s /usr/local/bin/fish
fish -c fisher

# Allow ~/Dropbox/Apps path for Alfred preferences
defaults write com.runningwithcrayons.Alfred-Preferences dropbox.allowappsfolder -bool TRUE

# Restart QuickLook
qlmanage -r

# Show ~/Library folder
chflags nohidden ~/Library/

# Customise Dock
dockutil --no-restart --remove all
dockutil --no-restart --add "/System/Applications/System Preferences.app"
dockutil --no-restart --add "/System/Applications/Music.app"
dockutil --no-restart --add "/System/Applications/Messages.app"
dockutil --no-restart --add "/Applications/Airmail.app"
dockutil --no-restart --add "/Applications/VLC.app"
dockutil --no-restart --add "/System/Applications/Photos.app"
dockutil --no-restart --add "/Applications/ReadKit.app"
dockutil --no-restart --add "/Applications/Wunderlist.app"
dockutil --no-restart --add "/System/Applications/Notes.app"
dockutil --no-restart --add "/Applications/1Password 7.app"
dockutil --no-restart --add "/Applications/Outbank.app"
dockutil --no-restart --add "/Applications/Google Chrome.app"
dockutil --no-restart --add "/Applications/Google Chrome Canary.app"
dockutil --no-restart --add "/Applications/Safari.app"
dockutil --no-restart --add "/Applications/Tower.app"
dockutil --no-restart --add "/Applications/Sublime Text.app"
dockutil --no-restart --add "/Applications/Visual Studio Code.app"
dockutil --no-restart --add "/Applications/RunJS.app"
dockutil --no-restart --add "/Applications/Sequel Pro.app"
dockutil --no-restart --add "/Applications/0xED.app"
dockutil --no-restart --add "/System/Applications/Utilities/Console.app"
dockutil --no-restart --add "/System/Applications/Utilities/Activity Monitor.app"
dockutil --no-restart --add "/Applications/iTerm.app"

killall Dock

# Defaults
./defaults.sh

# Add Go2Shell to Finder
./finder.sh

duti handlers.duti

# Create locate database
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist

# Set default DNS
networksetup -setdnsservers Wi-Fi 1.1.1.1 1.0.0.1 2606:4700:4700::1111 2606:4700:4700::1001
