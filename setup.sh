xcode-select --install

if test ! $(which brew); then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew bundle
brew cask install https://raw.githubusercontent.com/eenick/homebrew-cask/fadcd564c0afe00786df5eacdc42d9ba31dd23a7/Casks/tower.rb

read -p "Setup Dropbox and press any key..."

defaults write com.runningwithcrayons.Alfred-Preferences-3 dropbox.allowappsfolder -bool TRUE

mackup restore

echo /usr/local/bin/fish | sudo tee -a /etc/shells
chsh -s /usr/local/bin/fish
curl -L https://get.oh-my.fish | fish

qlmanage -r

chflags nohidden ~/Library/

