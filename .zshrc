export ZSH=/Users/zm/.oh-my-zsh

ZSH_THEME="powerlevel9k/powerlevel9k"

plugins=(
  git
  osx
  dotenv
  brew
  npm
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

zstyle ':bracketed-paste-magic' active-widgets '.self-*'
bindkey "^X\\x7f" backward-kill-line

autoload -Uz promptinit
autoload bashcompinit
bashcompinit

AWS_DEFAULT_PROFILE="default"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status aws load time)

sslcheck () {
  echo | openssl s_client -connect "${1}:443" -servername $1 2>/dev/null | openssl x509 -noout -dates
}
dps () { 
  docker ps -a --format="table {{.Names}}\t{{.ID}}\t{{.Status}}\t{{.RunningFor}}\t{{.Image}}" 
}
dent () {
    local CONTAINER_NAME=$1
    printf "\033[1;32mRunning interactive shell for '${CONTAINER_NAME}'\033[0m \n"
    docker exec -it -e TERM=xterm-256color $CONTAINER_NAME /bin/bash -c "export COLUMNS=`tput cols`; export LINES=`tput lines`; exec bash"
}
__dent () {
    COMPREPLY=( $(docker ps --format "{{.Names}}" -f name=$2) );
}
gcj () { 
  git commit -m "[$(current_branch)] $1" 
}
gcjn () { 
  echo "\033[1;32mCommiting wihout running git hooks\033[0m"
  mv .git/hooks .git/hooks2 > /dev/null 2>&1
  git commit -m "[$(current_branch)] $1" 
  mv .git/hooks2 .git/hooks > /dev/null 2>&1
}
gcja () { 
  git commit -am "[$(current_branch)] $1" 
}
gcjna () { 
  echo "\033[1;32mCommiting wihout running git hooks\033[0m"
  mv .git/hooks .git/hooks2 > /dev/null 2>&1
  git commit -am "[$(current_branch)] $1" 
  mv .git/hooks2 .git/hooks > /dev/null 2>&1
}
ggpnv () {
  git push -u origin $(git_current_branch) --no-verify
}
gpfnv () {
    tput setaf 2
    echo "git force push no-verify (e.g. after rebase)"
    tput sgr0
    git push -f origin $(current_branch) --no-verify
}
gcbj () {
    tput setaf 2
    INDEV=$(jira indev)
    echo "$INDEV"
    tput sgr0
    gcb $(echo "$INDEV" | awk '{print substr($1, 1, length($1)-1)}')
}

alias vim='nvim'

complete -F __dent dent;

export GPG_TTY=$(tty)
export EDITOR='nvim'
export ZSH_THEME_TERM_TITLE_IDLE="$(git_current_branch) %~"

export PATH="$HOME/.npm-packages/bin:$PATH"
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
