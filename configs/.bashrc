alias ll='ls -alFoLG'
alias c='clear'
alias cdp='cd ~/Projects'
alias clean_branches="git branch | grep -v "dev" | xargs git branch -D"
alias v="nvim"
alias vim="nvim"
alias dotread="c && cat mdp ~/Projects/better-dotfiles/README.md"

set -o vi

GIT_PS1_SHOWUPSTREAM="auto"
GIT_PS1_SHOWCOLORHINTS="yes"
GIT_PS1_SHOWDIRTYSTATE="yes"
GIT_PS1_SHOWUNTRACKEDFILES="yes"

source ~/.git-prompt.sh
source ~/.git-completion.sh

magenta=$(tput setaf 5)
blue=$(tput setaf 4) 
reset=$(tput sgr0)

#export PROMPT_COMMAND='__git_ps1 "\u@\h:\W" "\\\$ ";'
export PROMPT_COMMAND='__git_ps1 "\[$reset\][\[$blue\]\W\[$reset\]]" " ~ ";'

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

