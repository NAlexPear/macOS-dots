#!/bin/bash

# force rename to proper directory
if [ ! "$PWD" == "$HOME/config" ]; then
  mv "$PWD" ~/.config
fi

# initialize submodules
git submodule init
git submodule update --remote

# symlink config files
ln -s ~/.*rc ~

# set up homebrew if needed
if [ ! $(which brew) ]; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# forumulae
brew upgrade
brew install ruby git fd bat neovim
brew install koekeishiya/formulae/skhd

# taps
brew tap crisidev/homebrew-chunkwm
brew install chunkwm
brew tap caskroom/fonts
brew cask install font-iosevka

# services
brew services start chunkwm
brew services start skhd

# terminal configuration
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# node
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
source ~/.zshrc

# neovim providers
pip3 install --user neovim
npm install -g neovim
gem install neovim

# iTerm2
cp ~/.config/iTerm2/com.googlecode.iterm2.plist ~/Library/Preferences/
