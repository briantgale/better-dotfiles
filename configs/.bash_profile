[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# Allow for a local bashrc to be loaded if there is one
if [ -f ~/.bashrc.local ]; then
  . ~/.bashrc.local
fi

# Load bashrc
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi
