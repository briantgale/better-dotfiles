set -o vi
# source ~/.bin/tmuxinator.bash
source ~/.fzf.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='ag --ignore --hidden --ignore-dir vendor -g ""'
export FZF_DEFAULT_OPTS='
--color fg:252,bg:234,hl:67,fg+:84,bg+:234,hl+:67
--color info:144,prompt:161,spinner:135,pointer:84,marker:118
'

export VISUAL=nvim
export EDITOR="$VISUAL"

alias ll='exa -la'
alias c='clear'
alias cdp='cd ~/Projects'
alias dot='cd ~/Projects/better-dotfiles'
alias clean_branches="git branch | grep -v "dev" | xargs git branch -D"
alias v="nvim"
alias vim="nvim"
alias dotread="c && cat mdp ~/Projects/better-dotfiles/README.md"
alias gs="git stash"
alias gsl="git stash list"
alias pop="git stash pop"

# GIT_PS1_SHOWUPSTREAM="auto"
# GIT_PS1_SHOWCOLORHINTS="yes"
# GIT_PS1_SHOWDIRTYSTATE="yes"
# GIT_PS1_SHOWUNTRACKEDFILES="yes"
# 
# source ~/.git-prompt.sh
# source ~/.git-completion.sh

magenta=$(tput setaf 5)
blue=$(tput setaf 4) 
reset=$(tput sgr0)

export GPG_TTY=$(tty)

#export PROMPT_COMMAND='__git_ps1 "\u@\h:\W" "\\\$ ";'
export PROMPT_COMMAND='__git_ps1 "\[$reset\][\[$blue\]\W\[$reset\]]" " ~ ";'
# export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

cat << "EOF"
                                _____
                       __...---'-----`---...__
                  _===============================
 ______________,/'      `---..._______...---'
(____________LL). .    ,--'
 /    /.---'       `. /
'--------_  - - - - _/
          `~~~~~~~~'
... to boldly go where no one has gone before ...

EOF

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
