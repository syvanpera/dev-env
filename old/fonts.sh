#!/bin/bash

FONT_DIR=$HOME/.local/share/fonts

if [ ! -d "$FONT_DIR" ]; then
  mkdir -p $FONT_DIR
fi

if [ ! -f "$FONT_DIR/PowerlineSymbols.otf" ]; then
  wget -O $FONT_DIR/PowerlineSymbols.otf https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
  wget -O $FONT_DIR/fontawesome-regular.ttf https://github.com/gabrielelana/awesome-terminal-fonts/raw/master/build/fontawesome-regular.ttf
  wget -O $FONT_DIR/fontawesome-regular.sh https://github.com/gabrielelana/awesome-terminal-fonts/raw/master/build/fontawesome-regular.sh
  wget -O $FONT_DIR/devicons-regular.ttf https://github.com/gabrielelana/awesome-terminal-fonts/raw/master/build/devicons-regular.ttf
  wget -O $FONT_DIR/devicons-regular.sh https://github.com/gabrielelana/awesome-terminal-fonts/raw/master/build/devicons-regular.sh
  wget -O $FONT_DIR/octicons-regular.ttf https://github.com/gabrielelana/awesome-terminal-fonts/raw/master/build/octicons-regular.ttf
  wget -O $FONT_DIR/octicons-regular.sh https://github.com/gabrielelana/awesome-terminal-fonts/raw/master/build/octicons-regular.sh

  fc-cache -vf $FONT_DIR
fi
