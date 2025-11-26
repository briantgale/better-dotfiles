# Briant's Better Dotfiles

![Terminals Forever](terminals-forever.jpeg)

This repo contains my dotfiles, as well as a few scripts used to make maintaining them on multiple machines simpler.

## Ansible-based setup (new)

This repository now includes an Ansible playbook that replaces the old shell scripts for linking dotfiles, installing Homebrew packages, setting up Neovim/tmux/Zsh, Powerline fonts, npm globals, and iTerm2 preferences.

Quick start:

- Prereqs: Ansible installed (brew install ansible) and Git.
- From the repo root, run:

  ansible-playbook ansible/site.yml -K

  The -K flag will prompt for your sudo password if needed by Homebrew or system tasks.

What it does (mirrors old scripts):
- Symlinks files from configs/ and scripts/ into your home directory
- Installs/updates Homebrew and packages defined in ansible/site.yml
- Ensures Neovim config and plugins (vim-plug) are installed
- Installs/updates Powerline fonts locally
- Installs tmux plugin manager (TPM) and plugins
- Installs Oh My Zsh (if you’re already using zsh) and zsh plugins
- Installs npm global packages listed in ansible/site.yml
- Copies iTerm2 preferences from configs/ if present and restarts cfprefsd

Options:
- You can toggle optional components like RVM by editing ansible/site.yml (set install_rvm: true).

Notes:
- The old scripts (setup.sh, install-apps.sh) remain for reference but the Ansible playbook is now the preferred and idempotent way to configure a machine.

## RubyMine and IdeaVim configuration

- IdeaVim: This repo includes a synced IdeaVim config at `configs/.ideavimrc`. The Ansible playbook will link it to `~/.ideavimrc` so RubyMine/WebStorm/IntelliJ with IdeaVim will pick it up automatically.
- RubyMine settings (optional): If you add a folder at `configs/rubymine` with any standard RubyMine setting subfolders (e.g., `keymaps`, `colors`, `options`, `inspection`, etc.), the playbook will detect your latest local RubyMine config directory on macOS and symlink each item from `configs/rubymine/*` into that directory. This lets you share editor color schemes, keymaps, inspections, and more across machines.

Notes on RubyMine detection on macOS:
- The playbook searches for the newest directory matching `RubyMine*` under:
  - `~/Library/Application Support/JetBrains/`
  - and falls back to `~/Library/Preferences/`
- If RubyMine isn't installed yet, the task is skipped. You can re-run the playbook after installing RubyMine.

## TMux Config

- Prefix - CTRL+ a
- Rename Session - <Prefix> + $
- List Windows - <Prefix> + w
- New Window - <Prefix> + c
- Next Window - <Prefix> + n
- Rename Window - <Prefix> + ,
- Maximize Window - <Prefix> + z
- Split Horizontally - <Prefix> + v
- Split Vertically - <Prefix> + b
- Navigate Panes - <Prefix> + [h,j,k,l]
- Show History - <Prefix> + ~
- Reload Config - <Prefix> + r
- Show Time - <Prefix> + t

## VIM Config
- , - Leader
- i - Insert Mode
- cc - Insert and indent current line
- o - Open new line below and set to insert mode
- O - Open new line above and set to insert mode
- , + o - Open a new below
- , + O - Open a new line above
- A - Set to insert mode at the end of the current line
- I - Set to insert mode at the beginning of the current line
- gg - Go to top of file
- G - Go to bottom of file
- d0 - Delete from cursor to beginning of line

### Buffers
- ; = Show buggers
- , + l = next buffer
- , + p = prev buffer

### Panes
- , + v = Horizontal Split
- , + b = Vertical Split
- , + q = Close
- ctrl + w + | = Maximize
- ctrl + w + '=' = Equal size
- ctrl + w + [hjkl] = Navigate 

### Plugins

#### File Nav
- ctrl + n = NERD Tree
- , + m = Buffers
- ctrl + p = Fuzzyfind

#### Git
- , + gg = Git messenger
- , + gb = Git blame
