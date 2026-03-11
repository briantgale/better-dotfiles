export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="amuse"
DEFAULT_USER="$(whoami)"

# Base plugins — available on all machines
plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
  docker
  colorize
  tmuxinator
)

# macOS-specific plugins
if [[ "$OSTYPE" == darwin* ]]; then
  plugins+=(macos)
fi

# Ruby/Rails plugins — load only if ruby tooling is present
if command -v bundle >/dev/null 2>&1 || command -v ruby >/dev/null 2>&1; then
  plugins+=(rails ruby bundler)
fi

source "$ZSH/oh-my-zsh.sh"

[ -f "$HOME/.dotfiles-common.sh" ] && source "$HOME/.dotfiles-common.sh"

# macOS-specific PATH entries
if [[ "$OSTYPE" == darwin* ]]; then
  [ -d "$HOME/rubyonmac" ] && export PATH="$HOME/rubyonmac:$PATH"
  [ -d "/Applications/RubyMine.app/Contents/MacOS" ] && export PATH="/Applications/RubyMine.app/Contents/MacOS:$PATH"
fi

# mise — version manager (if installed)
if [ -x "$HOME/.local/bin/mise" ]; then
  eval "$($HOME/.local/bin/mise activate zsh)"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
