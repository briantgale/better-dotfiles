# Briant's Better Dotfiles

![Terminals Forever](terminals-forever.jpeg)

This repo contains my dotfiles, as well as a few scripts used to make maintaining them on multiple machines simpler.

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
