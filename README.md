# dotfiles

## Fresh setup
```sh
# Install Homebrew - https://brew.sh/
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Clone this repo (example)
mkdir -p ~/dev/zachary
git clone git@github.com:zmilonas/dotfiles.git dev/zachary/dotfiles

# Install Prezto - https://github.com/sorin-ionescu/prezto#manual
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

# Link prezto configs
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

# Include p10k config
ln "~/dev/zachary/dotfiles/.p10k.zsh" ~/.p10k.zsh

# Add/Overwrite .zpreztorc
cp -f ~/dev/zachary/dotfiles/.zpreztorc ~/

# Source my .zshrc
echo "source ~/dev/zachary/dotfiles/.zshrc" >> ~/.zshrc

# Install important casks
brew install --cask google-chrome firefox spotify iterm2 visual-studio-code signal scroll-reverser monitorcontrol jetbrains-toolbox hiddenbar
```
