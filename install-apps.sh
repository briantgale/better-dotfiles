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
  brew install mdp
  brew install fzf
  brew install the_silver_searcher
 
 	gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
 	\curl -sSL https://get.rvm.io | bash -s stable
fi

