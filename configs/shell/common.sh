export VISUAL=nvim
export EDITOR="$VISUAL"

# FZF config — prefer fast search tools, fall back gracefully
if command -v ag >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='ag --ignore --hidden --ignore-dir vendor -g ""'
elif command -v fd >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude vendor'
fi
export FZF_DEFAULT_OPTS='
--color fg:252,bg:234,hl:67,fg+:84,bg+:234,hl+:67
--color info:144,prompt:161,spinner:135,pointer:84,marker:118
'

# File listing — use eza if available, fall back to ls
if command -v eza >/dev/null 2>&1; then
  alias ll='eza -la --sort name'
  alias tree='eza --tree'
else
  alias ll='ls -la'
fi

# Editor — prefer nvim, fall back to vim
if command -v nvim >/dev/null 2>&1; then
  alias v='nvim'
  alias vim='nvim'
fi

alias c='clear'
alias cdp='cd ~/Projects'
alias dot='cd ~/Projects/better-dotfiles'
alias clean_branches='git branch | grep -v "dev" | xargs git branch -D'
alias dotread='c && mdp ~/Projects/better-dotfiles/README.md'
alias gs='git stash'
alias gsl='git stash list'
alias pop='git stash pop'
alias python='python3'

export GPG_TTY="$(tty)"

# MOTD
[ -f "$HOME/.dotfiles-header-card.rb" ] && ruby "$HOME/.dotfiles-header-card.rb"

# Machine-specific overrides — create ~/.rc.local (not committed) for per-machine config
[ -f "$HOME/.rc.local" ] && . "$HOME/.rc.local"
