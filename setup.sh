xcode-select --install

if test ! $(which brew); then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew bundle

read -p "Setup Dropbox and press any key..."

defaults write com.runningwithcrayons.Alfred-Preferences-3 dropbox.allowappsfolder -bool TRUE

mackup restore

echo /usr/local/bin/fish | sudo tee -a /etc/shells
chsh -s /usr/local/bin/fish
curl -L https://get.oh-my.fish | fish

qlmanage -r

chflags nohidden ~/Library/

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
