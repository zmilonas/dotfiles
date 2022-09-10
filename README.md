# dotfiles

## Fresh setup
```sh
# Install Homebrew - https://brew.sh/
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Clone this repo (example)
mkdir -p ~/dev/zachary
git clone git@github.com:zmilonas/dotfiles.git dev/zachary/dotfiles

cd dev/zachary/dotfiles
# Install Prezto - https://github.com/sorin-ionescu/prezto#manual
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

# (DEPRECATED) This installs oh my zsh, powerlevel10k and plugins for zsh.
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Include p10k config
ln "$(pwd)/.p10k.zsh" ~/.p10k.zsh

# Install all formulaes and casks (including iTerm)
brew bundle
```
