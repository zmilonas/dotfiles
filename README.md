# Zachary's dotfiles
![image](https://user-images.githubusercontent.com/25948390/225903151-6b453c3a-f8f3-4938-b251-ea0ce8148058.png)

## Fresh setup
```sh
export DOTFILES_PARENT="$HOME/dev/zachary"
export DOTFILES_DIR="$DOTFILES_PARENT/dotfiles"
cd $HOME

# Install Homebrew - https://brew.sh/
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Clone this repo (example)
mkdir -p $DOTFILES_PARENT
git clone git@github.com:zmilonas/dotfiles.git $DOTFILES_DIR

# Install Prezto - https://github.com/sorin-ionescu/prezto#manual
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

# Link prezto configs
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

# Include p10k config
ln "$DOTFILES_DIR/.p10k.zsh" ~/.p10k.zsh

# Add/Overwrite .zpreztorc
cp -f $DOTFILES_DIR/.zpreztorc ~/

# Source my .zshrc
echo "source $DOTFILES_DIR/.zshrc" >> ~/.zshrc

# Install important casks
brew bundle --file="$DOTFILES_DIR"
```
