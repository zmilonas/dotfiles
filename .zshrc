if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[[ ! -f "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]] || source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"

zstyle ':bracketed-paste-magic' active-widgets '.self-*'
bindkey "^X\\x7f" backward-kill-line
autoload -Uz promptinit
autoload bashcompinit
bashcompinit

git_current_branch() {
  local ref
  ref=$(git symbolic-ref --quiet HEAD 2> /dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return  # no git repo.
    ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  fi
  echo ${ref#refs/heads/}
}
redirects_curl () {
        curl -sIL $1 | grep --color=never -iE '^loc|^HTTP|^\s'
}
sslcheck () {
  echo | openssl s_client -connect "${1}:443" -servername $1 2>/dev/null | openssl x509 -noout -dates
}
git_current_branch_jira_ticket_id() {
         git_current_branch | grep --color=never -oE '[A-Z]{2,}-\d+' || echo "NOTICKET"
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
current_ticket_name() {
        jira indev | cut -d' ' -f5-
}
gcj () {
  DEFAULT_MSG="$(current_ticket_name)"
  MSG=${1:-$DEFAULT_MSG}
  git commit -m "$(git_current_branch_jira_ticket_id): $MSG"
}
gcja () {
  DEFAULT_MSG="$(current_ticket_name)"
  MSG=${1:-$DEFAULT_MSG}
  git commit -am "$(git_current_branch_jira_ticket_id): $MSG"
}
gcjn () { 
  echo "\033[1;32mCommiting wihout running git hooks\033[0m"
  mv .git/hooks .git/hooks2 > /dev/null 2>&1
  git commit -m "$(git_current_branch_jira_ticket_id): $1" 
  mv .git/hooks2 .git/hooks > /dev/null 2>&1
}
gcjna () { 
  echo "\033[1;32mCommiting wihout running git hooks\033[0m"
  mv .git/hooks .git/hooks2 > /dev/null 2>&1
  git commit -am "$(git_current_branch_jira_ticket_id): $1" 
  mv .git/hooks2 .git/hooks > /dev/null 2>&1
}
ggpnv () {
  git push -u origin $(git_current_branch) --no-verify
}
jv () {
  jira view $(git_current_branch_jira_ticket_id)
}
gpfnv () {
    tput setaf 2
    echo "git force push no-verify (e.g. after rebase)"
    tput sgr0
    git push -f origin $(git_current_branch) --no-verify
}
gcbj () {
    tput setaf 2
    INDEV=$(jira indev)
    echo "$INDEV"
    tput sgr0
    gcb $(echo "$INDEV" | awk '{print substr($1, 1, length($1)-1)}')
}
issue_in_progress() {
    jira indev | awk '{print substr($1, 1, length($1)-1)}'
}
to_code_review() {
    _ISSUE="$(issue_in_progress)"
    lab mr create -d -m
}
gcmj () {
        git commit -m "$(jira indev | awk '{$1="";  print substr($0,2)}')"
}
touchid_sudo() {
        enable_touchid="auth       sufficient     pam_tid.so"
        sudo sed -i '' -e "1s/^//p; 1s/^.*/${enable_touchid}/" /etc/pam.d/sudo 2>&1 > /dev/null 
}

jsondiff () {
        # https://stackoverflow.com/a/31933234
        jq --argfile a "$1" --argfile b "$2" -n '($a | (.. | arrays) |= sort) as $a | ($b | (.. | arrays) |= sort) as $b | $a == $b'
}
precmd () {
	echo -ne "\033]0;$(pwd)\007"
}

alias vim='nvim'
alias doc='docker compose'
alias doclift='docker compose logs -f --tail=30'
alias ffmpeg='ffmpeg -hide_banner'
alias ffprobe='ffprobe -hide_banner -pretty'
alias yt-dl-mp3='yt-dlp -x --audio-format mp3 --embed-thumbnail --embed-metadata -o "%(title)s.%(ext)s"'
alias gss='git status --short'
alias ggsup='git branch --set-upstream-to=origin/$(git_current_branch)'
alias glog='git log --oneline --decorate --graph'
alias ggp='git push origin $(git_current_branch)'

complete -F __dent dent;

export GOPATH="${HOME}/.go"
export GOROOT="$(brew --prefix golang)/libexec"
export GPG_TTY=$(tty)
export EDITOR='nvim'
export VISUAL='nvim'
export HOMEBREW_AUTO_UPDATE_SECS="604800"

export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.jetbrains/bin:$PATH"
export PATH="$PATH:${GOPATH}/bin"
export PATH="$PATH:/usr/local/sbin"

if type bat > /dev/null; then
        alias cat='bat'
fi


