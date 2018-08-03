export ZSH=/Users/zm/.oh-my-zsh

ZSH_THEME="agnoster"

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
alias md="mkdir"
dkill () { 
  docker kill $(docker ps -q) 
}
dcp () { 
  docker-compose up -d --force-recreate 
}
dcd () { 
  docker-compose down --remove-orphans 
}
dps () { 
  docker ps -a --format="table {{.Names}}\t{{.ID}}\t{{.Status}}\t{{.RunningFor}}\t{{.Image}}" 
}
dent () {
    # Docker ENTer (Container)
    local FIRST_CONTAINER=$(docker ps -q | head -n1)
    local CONTAINER=${1:=$FIRST_CONTAINER}
    local CONTAINER_NAME=$(docker ps --format="{{.Names}}" -f "id=${CONTAINER}")
    printf "\033[1;32mRunning interactive shell for '${CONTAINER_NAME}'\033[0m \n"
    docker exec -it -e TERM=xterm-256color $CONTAINER /bin/bash -c "export COLUMNS=`tput cols`; export LINES=`tput lines`; exec bash"
}
gcj () {
  # Git Commit Jira 
  git commit -m "[$(current_branch)] $1" 
}
gcja () {
  # Git Commit Jira All 
  git commit -a -m "[$(current_branch)] $1" 
}
ggpnv () {
  git push -u origin $(git_current_branch) --no-verify
}

export PATH="$HOME/.npm-packages/bin:$PATH"
export GPG_TTY=$(tty)
