set -o vi

[ -f "$HOME/.dotfiles-common.sh" ] && source "$HOME/.dotfiles-common.sh"

blue=$(tput setaf 4)
reset=$(tput sgr0)
export PROMPT_COMMAND='__git_ps1 "\[$reset\][\[$blue\]\W\[$reset\]]" " ~ ";'

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
