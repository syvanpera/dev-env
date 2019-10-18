Development Environment Configuration with Ansible
==================================================

[![License: MIT](https://img.shields.io/badge/license-MIT%20License-blue.svg)](https://raw.githubusercontent.com/syvanpera/dev-env/master/LICENSE)

# Run it
```shell
wget -qO- https://raw.github.com/syvanpera/dev-env/master/bootstrap.sh | bash
```

# Disclaimer
This is just for personal convenience. It's not intended to be highly configurable and I'm most likely not following Ansible's conventions and best practices.

# Content
Note: if no version is specified it means the latest will be installed

## Essentials
* [fish](https://fishshell.com/)
* [git](https://git-scm.com/)
* [tmux](https://github.com/tmux/tmux/)
* [ripgrep](https://github.com/BurntSushi/ripgrep)

## SDKs & Runtimes
* [go](https://golang.org/)

## Editors & IDEs
* [neovim](https://neovim.io/)
* [emacs](https://www.gnu.org/software/emacs/)

## Other utilities
* [Spotify](https://www.spotify.com)

## Custom configuration
* Fonts
    * [powerline](https://github.com/powerline/powerline)
    * [awesome-terminal-fonts](https://github.com/gabrielelana/awesome-terminal-fonts)
    * [nerd-fonts](https://www.nerdfonts.com/)
* fish
    * Set as default shell
    * [Starship](https://starship.rs/) prompt
    * Add custom plugins:
        * [fish-nvm](https://github.com/jorgebucaran/fish-nvm)
        * [fisher](https://github.com/jorgebucaran/fisher)
        * [fzf](https://github.com/jethrokuan/fzf)
        * [z](https://github.com/jethrokuan/z)
    * Add autocompletion for:
        * nvm
        * kubectl
* Dotfiles
    * [yadm](https://yadm.io/)
    * [dotfiles](https://github.com/syvanpera/dotfiles)

# License
[MIT License](LICENSE)
