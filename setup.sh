font_revision_file=".powerline-fonts-git-revision"
font_dir="$PWD/fonts"

function install_font_repo() {
  git clone https://github.com/powerline/fonts.git --depth=1
  (cd "$font_dir" && ./install.sh)
}

function update_font_repo() {
  (cd "$font_dir" && chmod u+x uninstall.sh && ./uninstall.sh && git pull && ./install.sh)
}

function font_revision() {
  echo $(cd "$font_dir" && git rev-parse HEAD)  
}

echo -n "Link dotfiles and install packages (Y/n)?"; read answer
if [[ $answer != "n" ]] && [[ $answer != "N" ]] ; then

  # Remove old symlinks
  echo "[setup.sh] Remove old symlinks..."
	rm -f "$HOME/.tmux.conf"
	rm -f "$HOME/.git-completion.sh"
	rm -f "$HOME/.git-prompt.sh"
	rm -f "$HOME/.config/nvim/init.vim"
	rm -f "$HOME/.gitconfig"
	rm -f "$HOME/.bashrc"
	rm -f "$HOME/.bash_profile"
  rm -f "$HOME/.fzf-tmux.sh"
  rm -f "$HOME/.bin/tmuxinator.bash"
k
  ## Add new symlinks
  echo "[setup.sh] Symlinking config files..."
	ln -s "$PWD/configs/.tmux.conf" "$HOME/.tmux.conf"
	ln -s "$PWD/configs/.git-completion.sh" "$HOME/.git-completion.sh"
	ln -s "$PWD/configs/.git-prompt.sh" "$HOME/.git-prompt.sh"
	ln -s "$PWD/configs/.gitconfig" "$HOME/.gitconfig"
	ln -s "$PWD/configs/.bash_profile" "$HOME/.bash_profile"
	ln -s "$PWD/configs/.bashrc" "$HOME/.bashrc"
  ln -s "$PWD/scripts/.fzf-tmux.sh" "$HOME/.fzf-tmux.sh"

  mkdir -p ~/.bin
  ln -s "$PWD/scripts/tmuxinator.bash" "$HOME/.bin/tmuxinator.bash"

  ## NVim & Install vim plugins
  echo "[setup.sh] Setting up nvim packages..."
	mkdir -p ~/.config/nvim 
	ln -s "$PWD/configs/init.vim" "$HOME/.config/nvim/init.vim"
  nvim +silent +PlugInstall +qall
  echo "y y n" | ~/.fzf/install

  #####################
  ## Powerline fonts ##
  #####################
  # https://github.com/powerline/fonts
  # Make sure we keep the same revision and deal with it
  echo "[setup.sh] Installing powerline fonts..."
  if [ ! -d "$PWD/fonts" ]; then
    install_font_repo
  fi

  git fetch
  remote_revision=$(cd "$font_dir" && git rev-parse master@{upstream})

  if [ $remote_revision == $(font_revision) ]; then
    echo "[setup.sh] Powerline font upsteam matches"
  else
    echo "[setup.sh] There is a new version of powerline, updating fonts..."
    update_font_repo
  fi

  # Tmux plugins
  echo "[setup.sh] Setting up tmux packages..."
  tpm_dir="$HOME/.tmux/plugins"

  if [ -d "$tpm_dir" ]; then
    (cd "$tpm_dir" && cd tpm && git pull)
  else
    mkdir -p "$tpm_dir"
    (cd "$tpm_dir" && git clone https://github.com/tmux-plugins/tpm)
  fi

  ~/.tmux/plugins/tpm/bin/install_plugins

  #################
  ## ITerm Prefs ##
  #################
  cp -rf configs/com.googlecode.iterm2.plist ~/Library/Preferences
  (cd ~/Library/Preferences && defaults read com.googlecode.iterm2.plist)
  killall cfprefsd

  echo "[setup.sh] ITerm preferences installed - quit and reopen to take effect"
fi
