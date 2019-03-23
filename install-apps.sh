function checkAndInstallPackage() {
  RESULT=`brew list $1`

  if [[ $RESULT == "" ]]; then
    echo "[install-apps] Installing $1..."
    brew install $1

    if [$2 == true]; then
      echo "[install-apps]Force linking $1"
      brew link $1 --force
    fi
  else
    echo "[install-apps] $1 is already installed..."
  fi
}

function checkAndInstallGem() {
  RESULT=`gem list -i $1`

  if [[ $RESULT == "true" ]]; then
    echo "[install-apps] Gem installed $1"
  else
    echo "[install-apps] Installing gem $1..."
    gem install $1
  fi
}

function checkAndInstallNpm() {
  RESULT=`npm list -g $1`

  if [[ $RESULT == *"empty"* ]]; then
    echo "[install-apps] Installing npm $1..."
    npm install $1 -g
  else
    echo "[install-apps] NPM installed $1"
  fi
}

echo -n "Install all base packages (Y/n)?"; read answer
if [[ $answer == "y" ]] || [[ $answer == "Y" ]] ; then
  echo "[install-apps] Checking for homebrew..."

  BREW=`which brew`
  if [[ $BREW == "" ]]; then
    echo "[install-apps] Installing homebrew..."
    sudo chown -R $(whoami):admin /usr/local
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else
    echo "[install-apps] Homebrew installed"
  fi

  brew doctor
  brew update

  checkAndInstallPackage "neovim"
  checkAndInstallPackage "tmux"
  checkAndInstallPackage "git"
  checkAndInstallPackage "redis"
  checkAndInstallPackage "terminal-notifier"
  checkAndInstallPackage "mdp"
  checkAndInstallPackage "fzf"
  checkAndInstallPackage "the_silver_searcher"
  checkAndInstallPackage "npm"
  checkAndInstallPackage "cmatrix"

  echo "[install-apps] Checking RVM..."

  RVM=`which rvm`
  if [[ $RVM == "" ]]; then
    echo "[install-apps] Installing RVM..."
    gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
    \curl -sSL https://get.rvm.io | bash -s stable
  else
    echo "[install-apps] RVM already installed"
  fi

  echo "[install-apps] Setting up additional packages..."

  #checkAndInstallGem "colorls"
  checkAndInstallGem "tmuxinator"
  checkAndInstallNpm "gtop"
fi

