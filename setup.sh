echo -n "Install all base packages (Y/n)?"; read answer
if [[ $answer != "n" ]] && [[ $answer != "N" ]] ; then
  sudo chown -R $(whoami):admin /usr/local
 	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
 
 	brew doctor
 	brew update
 
 	brew install neovim
 	brew install tmux
 	brew install git
 	brew install redis
 	brew install terminal-notifier
 
 	gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
 	\curl -sSL https://get.rvm.io | bash -s stable
 
fi

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

  # Add new symlinks
  echo "[setup.sh] Symlinking config files..."
	ln -s "$PWD/configs/.tmux.conf" "$HOME/.tmux.conf"
	ln -s "$PWD/configs/.git-completion.sh" "$HOME/.git-completion.sh"
	ln -s "$PWD/configs/.git-prompt.sh" "$HOME/.git-prompt.sh"
	ln -s "$PWD/configs/.gitconfig" "$HOME/.gitconfig"
	ln -s "$PWD/configs/.bash_profile" "$HOME/.bash_profile"
	ln -s "$PWD/configs/.bashrc" "$HOME/.bashrc"

  # NVim & Install vim plugins
  echo "[setup.sh] Setting up nvim packages..."
	mkdir -p ~/.config/nvim 
	ln -s "$PWD/configs/init.vim" "$HOME/.config/nvim/init.vim"
  nvim +silent +PlugInstall +qall

  # Tmux plugins
  echo "[setup.sh] Setting up tmux packages..."
  tpm_dir="~/.tmux/plugins/tpm"

  if [ -d "$tpm_dir" ]; then
    (cd "$tpm_dir" && git pull)
  else
    git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
  fi

  ~/.tmux/plugins/tpm/bin/install_plugins
fi
