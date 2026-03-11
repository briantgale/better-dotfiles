#!/usr/bin/env bash

set -euo pipefail

log() {
  printf '[bootstrap] %s\n' "$*"
}

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    log "Missing required command: $1"
    exit 1
  fi
}

install_macos() {
  require_cmd curl

  if ! command -v brew >/dev/null 2>&1; then
    log "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    log "Homebrew already installed."
  fi

  if ! command -v ansible >/dev/null 2>&1; then
    log "Installing Ansible via Homebrew..."
    brew install ansible
  else
    log "Ansible already installed."
  fi
}

install_debian() {
  if ! command -v sudo >/dev/null 2>&1; then
    log "sudo is required on Debian/Ubuntu systems."
    exit 1
  fi

  log "Installing prerequisites via apt..."
  sudo apt-get update
  sudo apt-get install -y ansible git curl
}

main() {
  local os_name
  os_name="$(uname -s)"

  case "$os_name" in
    Darwin)
      install_macos
      ;;
    Linux)
      if [ -r /etc/os-release ]; then
        # shellcheck disable=SC1091
        . /etc/os-release
      fi

      case "${ID:-}" in
        debian|ubuntu)
          install_debian
          ;;
        *)
          case "${ID_LIKE:-}" in
            *debian*)
              install_debian
              ;;
            *)
              log "Unsupported Linux distribution. This bootstrap supports Debian/Ubuntu."
              exit 1
              ;;
          esac
          ;;
      esac
      ;;
    *)
      log "Unsupported OS: $os_name"
      exit 1
      ;;
  esac

  log "Bootstrap complete."
  log "Next step: ansible-playbook ansible/site.yml -K"
}

main "$@"
