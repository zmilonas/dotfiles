# Zachary's dotfiles

![image](https://github.com/zmilonas/dotfiles/assets/25948390/0b895cc2-78ce-45ec-b2d2-075fb7bfd54c)


|      Category   |              |
|-----------------|---------------|
| OS              | macOS         |
| Shell           | zsh           |
| Package Manager | [Homebrew](https://brew.sh/)      |
| zsh framework   | [Prezto](https://github.com/sorin-ionescu/prezto)        |
| Emulator        | Alacritty     |
| Theme           | [Powerlevel10k](https://github.com/romkatv/powerlevel10k) |
| IDE             | [JetBrains](https://www.jetbrains.com/products/#lang=js&lang=go&lang=python&lang=sql)     |
| Editor          | NeoVim        | 


## Fresh setup

**Warning: this overwrites some important shell configuration files, proceed with caution** 

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

# Install Tmux Plugin Manager (TPM)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Symlink config files - term, git, p10k, nvim etc.
mkdir -p ~/.config/{bat,alacritty,tmux}
mv ~/.zpreztorc ~/.zpreztorc.bak
ln -s "$DOTFILES_DIR/.p10k.zsh" ~/.p10k.zsh
ln -s "$DOTFILES_DIR/.gitconfig" ~/.gitconfig
ln -s "$DOTFILES_DIR/.zpreztorc" ~/.zpreztorc
ln -s "$DOTFILES_DIR/.vimrc" ~/.vimrc
ln -s "$DOTFILES_DIR/alacritty.toml" ~/.config/alacritty/alacritty.toml
ln -s "$DOTFILES_DIR/bat.conf" ~/.config/bat/config
ln -s "$DOTFILES_DIR/tmux.conf" ~/.config/tmux/tmux.conf
ln -s "$DOTFILES_DIR/nvim-init.lua" ~/.config/nvim/init.lua

# Source my .zshrc
echo "source $DOTFILES_DIR/.zshrc" >> ~/.zshrc

# Install important casks
brew bundle --file="$DOTFILES_DIR"
```

## Troubleshooting

See where git configs come from:
```
git config --list --show-origin
```

