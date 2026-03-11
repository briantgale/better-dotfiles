# Briant's Better Dotfiles

![Terminals Forever](terminals-forever.jpeg)

## Setup

Prerequisites:
- macOS: `brew install ansible` and Git
- Debian/Ubuntu: `sudo apt install ansible` and Git

To install the minimum prerequisites first:

```sh
./scripts/bootstrap-ansible.sh
```

Then from the repo root:

```sh
ansible-playbook ansible/site.yml -K
```

The `-K` flag prompts for your sudo password if needed.

What the playbook does:
- Symlinks configs and scripts into your home directory
- Installs packages via `brew` (macOS) or `apt` (Debian/Ubuntu)
- Sets up Neovim with vim-plug
- Installs Powerline fonts
- Installs tmux plugin manager (TPM) and plugins
- Installs Oh My Zsh and zsh plugins
- Copies iTerm2 preferences (macOS only)

Tags:
- `ansible-playbook ansible/site.yml -K --tags platform` — packages only
- `ansible-playbook ansible/site.yml -K --tags dotfiles,shell` — symlinks and shell only

## Machine-specific configuration

Two files are excluded from the repo and must be created per machine:

**`~/.rc.local`** — shell overrides (aliases, PATH entries, etc.)
Copy [`configs/shell/local/.rc.local.example`](configs/shell/local/.rc.local.example) to `~/.rc.local`.

**`~/.gitconfig.local`** — git user identity
Copy [`configs/git/.gitconfig.local.example`](configs/git/.gitconfig.local.example) to `~/.gitconfig.local`.

## Shell config layout

```
configs/shell/
├── common.sh          # shared config for all shells and machines
├── motd.sh            # welcome message on new sessions
├── bash/
│   ├── .bash_profile
│   └── .bashrc
├── zsh/
│   └── .zshrc
└── local/
    └── .rc.local.example
```

`common.sh` is symlinked to `~/.dotfiles-common.sh` and sourced by both `.bashrc` and `.zshrc`. Machine-specific overrides go in `~/.rc.local` (not committed).

## RubyMine and IdeaVim

The IdeaVim config at `configs/editor/.ideavimrc` is symlinked to `~/.ideavimrc` automatically.

If you add RubyMine settings to `configs/rubymine/` (e.g. `keymaps`, `colors`, `options`), the playbook will detect your RubyMine config directory on macOS and symlink each item into it.

## tmux

- Prefix: `ctrl+a`
- Rename session: `<prefix> $`
- List windows: `<prefix> w`
- New window: `<prefix> c`
- Next window: `<prefix> n`
- Rename window: `<prefix> ,`
- Maximize pane: `<prefix> z`
- Split horizontal: `<prefix> v`
- Split vertical: `<prefix> b`
- Navigate panes: `<prefix> h/j/k/l`
- Show history: `<prefix> ~`
- Reload config: `<prefix> r`
- Show time: `<prefix> t`

## Vim / Neovim

Leader key: `,`

### Navigation
- `gg` — top of file
- `G` — bottom of file
- `ctrl+p` — fuzzy find files
- `;` — show buffers
- `,l` — next buffer
- `,p` — prev buffer
- `ctrl+n` — NERDTree

### Panes
- `,v` — horizontal split
- `,b` — vertical split
- `,q` — close
- `ctrl+w |` — maximize
- `ctrl+w =` — equal size
- `ctrl+w hjkl` — navigate

### Git
- `,gg` — git messenger
- `,gb` — git blame
