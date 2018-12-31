#!/bin/bash

# force rename to proper directory
if [ ! "$PWD" == "$HOME/.config" ]; then
  mv "$PWD" ~/.config/
fi

# initialize submodules
git submodule init
git submodule update --remote

# fonts (Ligaturized Iosevka)
curl -L https://github.com/be5invis/Iosevka/files/2300381/iosevka-term-with-fira-code-ligatures.zip | bsdtar -C ~/Library/Fonts -xvf-

# set up homebrew if needed
if [ ! $(which brew) ]; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# forumulae
brew upgrade
brew install ruby git fd bat neovim ripgrep htop fzf emojify httpie z tree
brew install koekeishiya/formulae/skhd

# taps
brew tap crisidev/homebrew-chunkwm
brew install chunkwm

# services
brew services start chunkwm
brew services start skhd

# terminal configuration
export ZSH="$HOME/.config/oh-my-zsh"; sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# symlink config files
rm ~/.zshrc
ln -sf ~/.config/.*rc ~

# rust
if [ ! $(which cargo) ]; then
  curl https://sh.rustup.rs -sSf | sh
fi

# node
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
source ~/.zshrc
nvm install node

# neovim providers
pip3 install --user neovim
npm install -g neovim
gem install neovim

# iTerm2
cp ~/.config/iTerm2/com.googlecode.iterm2.plist ~/Library/Preferences/

# Slack
cat ~/.config/slack-dark.js >> /Applications/Slack.app/Contents/Resources/app.asar.unpacked/src/static/ssb-interop.js

# Exit message
echo -e "\n==========\n"
echo "Configuration complete! Please restart your terminal"
