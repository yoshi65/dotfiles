#!/bin/zsh

diff -u ./.vimrc ~/.vimrc > d_rc

if [ ! -s ./d_rc ]; then
  echo "no diff"
else
  echo "diff"
  patch -u ./.vimrc < d_rc
fi

rm -f d_rc
