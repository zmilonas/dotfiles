# dotfiles

## Fresh setup
```sh
# Install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# Clone this repo
mkdir -p ~/dev/zachary
git clone git@github.com:zmilonas/dotfiles.git dev/zachary/dotfiles
cd dev/zachary/dotfiles
# Install Oh my Zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# Install p10k - https://github.com/romkatv/powerlevel10k#oh-my-zsh
# Include p10k config
ln ~/.p10k.zsh "$(pwd)/.p10k.zsh"
# install MesloLGS NF
# Install all formulaes and casks (including iTerm)
brew bundle
```
