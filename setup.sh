#!/usr/bin/env bash

# Xcode
xcode-select --install

# Homebrew
if test ! $(which brew); then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Install Brews, Casks and MAS apps
brew bundle

# Install Node
export NVM_DIR="$HOME/.nvm"
. "$(brew --prefix nvm)/nvm.sh"
nvm install stable

npm i -g jscs sass-lint

# Install Ruby
rbenv install `rbenv install -l | grep -v - | tail -1`

gem install bundler dotenv pry sass scss_lint

# Wait for Dropbox
read -p "Setup Dropbox and press any key..."

# Custom Casks
brew cask install ~/Dropbox/Code/Provisioning/phoneview.rb
cp ~/Dropbox/Code/Provisioning/PixelSnap-1.4.1.dmg ~/Library/Caches/Homebrew/Cask/pixelsnap--1.4.1.dmg && brew cask install ~/Dropbox/Code/Provisioning/pixelsnap.rb

# Allow ~/Dropbox/Apps path for Alfred preferences
defaults write com.runningwithcrayons.Alfred-Preferences-3 dropbox.allowappsfolder -bool TRUE

# Symlink application settings from Dropbox
mackup restore

# fish shell
echo /usr/local/bin/fish | sudo tee -a /etc/shells
chsh -s /usr/local/bin/fish
fish -c fisher

# Restart QuickLook
qlmanage -r

# Show ~/Library folder
chflags nohidden ~/Library/

# Customise Dock
dockutil --no-restart --remove all
dockutil --no-restart --add "/Applications/System Preferences.app"
dockutil --no-restart --add "/Applications/iTunes.app"
dockutil --no-restart --add "/Applications/Messages.app"
dockutil --no-restart --add "/Applications/Airmail 3.app"
dockutil --no-restart --add "/Applications/VLC.app"
dockutil --no-restart --add "/Applications/Photos.app"
dockutil --no-restart --add "/Applications/ReadKit.app"
dockutil --no-restart --add "/Applications/Wunderlist.app"
dockutil --no-restart --add "/Applications/Notes.app"
dockutil --no-restart --add "/Applications/1Password.app"
dockutil --no-restart --add "/Applications/Outbank.app"
dockutil --no-restart --add "/Applications/Google Chrome.app"
dockutil --no-restart --add "/Applications/Google Chrome Canary.app"
dockutil --no-restart --add "/Applications/Safari.app"
dockutil --no-restart --add "/Applications/Tower.app"
dockutil --no-restart --add "/Applications/Sublime Text.app"
dockutil --no-restart --add "/Applications/Visual Studio Code.app"
dockutil --no-restart --add "/Applications/Sequel Pro.app"
dockutil --no-restart --add "/Applications/0xED.app"
dockutil --no-restart --add "/Applications/Utilities/Console.app"
dockutil --no-restart --add "/Applications/Utilities/Activity Monitor.app"
dockutil --no-restart --add "/Applications/iTerm.app"

killall Dock

./defaults.sh

duti handlers.duti
