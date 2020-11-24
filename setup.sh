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

# Remove quarantine
xattr -r -d com.apple.quarantine /Applications 2> /dev/null
xattr -r -d com.apple.quarantine ~/Library/QuickLook

# Wait for Dropbox
read -p "Setup Dropbox and press any key..."

# Symlink application settings from Dropbox
mackup restore

# Setup version manager
source /usr/local/opt/asdf/asdf.sh

# Install Ruby
asdf plugin-add ruby
RUBY_VERSION=`asdf list-all ruby | grep -v [a-z] | tail -1`
asdf install ruby $RUBY_VERSION
asdf global ruby $RUBY_VERSION

# Install Node
asdf plugin-add nodejs
bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
NODE8_VERSION=`asdf list-all nodejs | grep -v [a-z] | grep '^8' | tail -1`
NODE10_VERSION=`asdf list-all nodejs | grep -v [a-z] | grep '^10' | tail -1`
NODE12_VERSION=`asdf list-all nodejs | grep -v [a-z] | grep '^12' | tail -1`
NODE_VERSION=`asdf list-all nodejs | grep -v [a-z] | tail -1`
asdf install nodejs $NODE8_VERSION
asdf install nodejs $NODE10_VERSION
asdf install nodejs $NODE12_VERSION
asdf install nodejs $NODE_VERSION
asdf global nodejs $NODE_VERSION

# Install Python
export LDFLAGS="-L/usr/local/opt/zlib/lib"
export CPPFLAGS="-I/usr/local/opt/zlib/include"
export PKG_CONFIG_PATH="/usr/local/opt/zlib/lib/pkgconfig"
export KEEP_BUILD_PATH=true
asdf plugin-add python
PYTHON2_VERSION=`asdf list-all python | grep -v [a-z] | grep '^2' | tail -1`
PYTHON3_VERSION=`asdf list-all python | grep -v [a-z] | grep '^3' | tail -1`
asdf install python $PYTHON2_VERSION
asdf install python $PYTHON3_VERSION
asdf global python $PYTHON3_VERSION $PYTHON2_VERSION

# Install gems and packages
gem install bundler dotenv pry sass scss_lint
npm i -g prettier sass-lint eslint eslint-config-standard eslint-plugin-import eslint-plugin-node eslint-plugin-promise eslint-plugin-standard eslint-config-prettier eslint-plugin-prettier
pip install pylint pyatv

# Custom Casks
brew cask install ~/Dropbox/Code/Provisioning/phoneview.rb
brew cask install ~/Dropbox/Code/Provisioning/pixelsnap2.rb
brew cask install ~/Dropbox/Code/Provisioning/airbuddy2.rb

# fish shell
echo /usr/local/bin/fish | sudo tee -a /etc/shells
chsh -s /usr/local/bin/fish
fish -c fisher

# Allow ~/Dropbox/Apps path for Alfred preferences
defaults write com.runningwithcrayons.Alfred-Preferences dropbox.allowappsfolder -bool TRUE
defaults write com.runningwithcrayons.Alfred-Preferences syncfolder -string "~/Dropbox/Apps"

# Restart QuickLook
qlmanage -r

# Show ~/Library folder
chflags nohidden ~/Library

# Hide ~/Applications folder
chflags hidden ~/Applications

# Customise Dock
dockutil --no-restart --remove all
dockutil --no-restart --add "/System/Applications/System Preferences.app"
dockutil --no-restart --add "/System/Applications/iTunes.app"
dockutil --no-restart --add "/System/Applications/Messages.app"
dockutil --no-restart --add "/Applications/Mimestream.app"
dockutil --no-restart --add "/Applications/VLC.app"
dockutil --no-restart --add "/System/Applications/Photos.app"
dockutil --no-restart --add "/Applications/ReadKit.app"
dockutil --no-restart --add "/Applications/TickTick.app"
dockutil --no-restart --add "/System/Applications/Notes.app"
dockutil --no-restart --add "/Applications/1Password 7.app"
dockutil --no-restart --add "/Applications/Outbank.app"
dockutil --no-restart --add "/Applications/Google Chrome.app"
dockutil --no-restart --add "/Applications/Google Chrome Canary.app"
dockutil --no-restart --add "/Applications/Safari.app"
dockutil --no-restart --add "/Applications/Gitfox.app"
dockutil --no-restart --add "/Applications/Sublime Text.app"
dockutil --no-restart --add "/Applications/Visual Studio Code.app"
dockutil --no-restart --add "/Applications/RunJS.app"
dockutil --no-restart --add "/Applications/Hex Fiend.app"
dockutil --no-restart --add "/System/Applications/Utilities/Console.app"
dockutil --no-restart --add "/System/Applications/Utilities/Activity Monitor.app"
dockutil --no-restart --add "/Applications/iTerm.app"

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
